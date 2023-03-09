import m_functions as mf
import os

print('####')

def main():
    is_update = input('是否更新到最新一期双色球数据?\n(y/n): ')
    if is_update == 'y':
        mf.requests_data()

    select_row = input('是否需要更改分析期数(默认: 最新30期)\n(y/n): ')
    if select_row != 'y':
        data = mf.print_lottery_data()
    else:
        row = int(input('请输入需要分析的期数: '))
        data = mf.print_lottery_data(row=row)

    is_make_combos = input('是否需要生成所有组合?\n(y/n): ')
    if is_make_combos == 'y':
        mf.make_all_combos()

    mf.debug_print('处理所有组合的数据...\n')
    is_check_consecutive_combos = input('是否去除包含3个或3个以上连号的组合?\n(y/n): ')
    if is_check_consecutive_combos == 'y':

        mf.exception_consecutive_numbers()

    
    mf.debug_print('处理不包含3个及3个以上连号的数据...\n')
    set_condition = input('请设定区间和每个区间应包含的数的数量\n比如: 1-11:2,12-22:2,23-33:2\n')
    intervals = {}
    for i in set_condition.split(','):
        count = int(i.strip().split(':')[1])
        temp = i.strip().split(':')[0]
        start = int(temp.strip().split('-')[0])
        end = int(temp.strip().split('-')[1])
        interval = (start,end)
        intervals[interval]= count      # 设定区间和每个区间应包含的数的数量

    set_exception_numbers = input('请输入想要排除的号码，用逗号隔开:\n')
    exception_numbers = []
    for i in set_exception_numbers.split(','):
        exception_numbers.append(int(i.strip()))     # 排除的号码

    mf.get_condition_data(intervals, exception_numbers)


if __name__ == '__main__':
    main()
    os.system('pause')