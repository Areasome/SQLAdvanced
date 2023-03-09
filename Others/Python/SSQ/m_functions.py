import os
from tabulate import tabulate
from collections import Counter

import itertools
import datetime
from tqdm import tqdm
import requests


def print_lottery_data(row=30, column=9):
    """打印往期开奖数据

    Args:
        row (int, optional): 行数. Defaults to 30.
        column (int, optional): 原始数据截至列数. Defaults to 9.
    """
    debug_print('开始读取数据...\n')

    # 读取数据(开奖信息)
    with open(os.getcwd() + '\\ssq_asc.txt', 'r') as f:
        data_lottery = []
        for line in f:
            fields = line.strip().split()[:column]
            data_lottery.append(fields)

    data_lottery = data_lottery[-row:]

    # 打印开奖数据
    headers = ('期号', '开奖日期', '红球1', '红球2', '红球3', '红球4', '红球5', '红球6', '蓝球')
    table = tabulate(data_lottery, headers=headers, tablefmt='psql')
    print(table)
    debug_print(f'打印{row}期数据完成!\n')


def requests_data():
    """请求更新数据并保存到本地
    """
    debug_print('开始更新开奖数据...\n')

    url = 'http://data.17500.cn/ssq_asc.txt'
    path = os.getcwd() + '\\ssq_asc.txt'
    headers = {
        'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.50'
    }

    rs = requests.get(url=url, headers=headers)
    if rs.status_code == 200:
        with open(path, 'wb') as f:
            f.write(rs.content)
            debug_print('更新开奖数据更新成功...\n')
    else:
        debug_print('更新数据更新失败, 请检查网络链接!\n')


def make_all_combos():
    """生成所有排列组合
    """

    # iterable: 可迭代的对象, 在手动更新时不需要进行设置
    # desc: 字符串, 左边进度条描述文字
    # total: 总的项目数
    # leave: bool值, 迭代完成后是否保留进度条
    # file: 输出指向位置, 默认是终端, 一般不需要设置
    # ncols: 调整进度条宽度, 默认是根据环境自动调节长度, 如果设置为0, 就没有进度条, 只有输出的信息
    # unit: 描述处理项目的文字, 默认是'it', 例如: 100 it/s, 处理照片的话设置为'img' ,则为 100 img/s
    # unit_scale: 自动根据国际标准进行项目处理速度单位的换算, 例如 100000 it/s >> 100k it/s

    debug_print('开始生成排列组合...\n')

    # 生成1到34的数字列表
    numbers = list(range(1, 34))

    # 1到33的数字中，任取6个数字进行排列组合计算
    combos = itertools.combinations(numbers, 6)

    # 将计算记过保存到txt文本中
    with tqdm(total=1107569, desc='生成排列组合:', leave=True, ncols=100) as pbar:
        for combo in combos:
            with open('all_combos.txt', 'a') as f:
                f.write(','.join(str(num) for num in combo) + '\n')
            # 更新进度条
            pbar.update(1)

    debug_print('生成排列组合完成!\n')


def chunk_data(row_size=10):
    """将开奖数据按指定行数进行分割汇总,统计每个数字出现的次数

    Args:
        row (int, optional): 指定要切割的行数. Defaults to 10.
    """
    debug_print('开始读取数据...\n')

    # 读取数据(开奖信息) 格式为二维List red1,red2,red3,red4,red5,red6,blue
    data_lottery = []
    with open('Others\Python\SSQ\ssq_asc.txt', 'r') as f:
        for line in f:
            fields = line.strip().split()[2:9]
            data_lottery.append(fields)

    data_rows = []
    result = []
    # 将数据切割为指定行数
    for i in range(0, len(data_lottery), row_size):
        rows = data_lottery[i:i + row_size]

        # 将数据转换成1维列表
        data_rows = [element for sublist in rows for element in sublist]

        # 统计数据出现次数
        rows_counter = Counter(data_rows)

        # 将Counter中的键按整数类型排序
        sorted_keys = sorted(map(int, rows_counter.keys()))

        # 创建一个新的Counter对象，并为缺失的键添加键值对
        new_counter = Counter({f'{k:02d}': 0 for k in range(1, 34)})
        new_counter.update(rows_counter)

        # 将新的Counter对象中的键按照排好序的键列表进行排序
        sorted_output = Counter({f'{k:02d}': new_counter[f'{k:02d}'] for k in sorted_keys})

        # 将结果字典保存到result里
        result.append(dict(sorted_output))

    # 转换字典为列表
    rows = [[r[k] for k in sorted(r.keys())] for r in result]

    # 打印表格
    print(tabulate(rows, headers=[f'red {k}' for k in range(1, 34)]))
    debug_print('按期统计数据数据完成!\n')


def debug_print(message):
    """打印带时间戳的调试信息到控制台

    Args:
        message (字符串): 调试信息
    """
    # 获取当前时间
    current_time = datetime.datetime.now()
    # 格式化时间戳字符串
    timestamp_str = current_time.strftime('[%Y-%m-%d %H:%M:%S]')
    # 打印带时间戳的调试信息
    print(f'{timestamp_str} {message}')
