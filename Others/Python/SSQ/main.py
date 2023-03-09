import m_functions as mf
import os


def main():
    is_update = input('是否需要下载更新到最新一期双色球数据?\n(y/n): ')
    if is_update == 'y':
        mf.requests_data()

    is_print = input('即将开始打印历史开奖数据, 是否需要更改期数(默认: 最新30期)\n(y/n): ')
    if is_print != 'y':
        mf.print_lottery_data()
    else:
        row = int(input('请输入需要打印的期数: '))
        mf.print_lottery_data(row=row)

    is_make_combos = input('是否需要生成所有组合?\n(y/n): ')
    if is_make_combos == 'y':
        mf.make_all_combos()

    is_chunk = input('即将开始打印历史每个数字出现的次数, 是否需要更改默认期数(默认: 以10期为分割)\n(y/n): ')
    if is_chunk != 'y':
        mf.chunk_data()
    else:
        row = int(input('请输入需要打印的期数: '))
        mf.chunk_data(row_size=row)


if __name__ == '__main__':
    main()
    os.system('pause')