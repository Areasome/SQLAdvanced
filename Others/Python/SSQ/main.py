import m_functions as mf
import os


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
    if is_make_combos =='y':
        mf.make_all_combos()

    

if __name__ == '__main__':
    main()
    os.system('pause')