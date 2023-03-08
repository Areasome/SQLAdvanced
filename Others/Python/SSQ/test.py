# from pyecharts.charts import Bar
# from pyecharts import options as opts

# # V1 版本开始支持链式调用
# bar = (
#     Bar()
#     .add_xaxis(["衬衫", "毛衣", "领带", "裤子", "风衣", "高跟鞋", "袜子"])
#     .add_yaxis("商家A", [114, 55, 27, 101, 125, 27, 105])
#     .add_yaxis("商家B", [57, 134, 137, 129, 145, 60, 49])
#     .set_global_opts(title_opts=opts.TitleOpts(title="某商场销售情况"))
# )
# bar.render()

# # 不习惯链式调用的开发者依旧可以单独调用方法
# bar = Bar()
# bar.add_xaxis(["衬衫", "毛衣", "领带", "裤子", "风衣", "高跟鞋", "袜子"])
# bar.add_yaxis("商家A", [114, 55, 27, 101, 125, 27, 105])
# bar.add_yaxis("商家B", [57, 134, 137, 129, 145, 60, 49])
# bar.set_global_opts(title_opts=opts.TitleOpts(title="某商场销售情况"))
# bar.render()


# import pyecharts

# print(pyecharts.__version__)


# import pandas as pd

# data = [[ 66386, 174296,  75131, 577908,  32015],
#         [ 58230, 381139,  78045,  99308, 160454],
#         [ 89135,  80552, 152558, 497981, 603535],
#         [ 78415,  81858, 150656, 193263,  69638],
#         [139361, 331509, 343164, 781380,  52269]]
# columns=('Freeze', 'Wind', 'Flood', 'Quake', 'Hail')

# rows = ['%d year'% x for x in (100, 50, 20, 10, 5)]
# df = pd.DataFrame(data, columns=('Freeze', 'Wind', 'Flood', 'Quake', 'Hail'),
#                   index=rows)
# print(df)



# # coding:utf-8
# from pyecharts.charts import Bar, Page
# from pyecharts import options as opts
# import os
# if __name__ == '__main__':
#     # pyecharts=1.8.1
#     # 安装 python -m pip install pyecharts
#     page = Page(layout=Page.DraggablePageLayout)
#     bar = Bar()
#     bar.add_xaxis(["衬衫", "毛衣", "领带", "裤子", "风衣", "高跟鞋", "袜子"])
#     bar.add_yaxis("商家A", [114, 55, 27, 101, 125, 27, 105])
#     bar.add_yaxis("商家B", [57, 134, 137, 129, 145, 60, 49])
#     bar.add_yaxis("商家C", [57, 134, 137, 129, 145, 60, 49])
#     bar.set_global_opts(title_opts=opts.TitleOpts(title="某商场销售情况1"))
#     bar1 = Bar()
#     bar1.add_xaxis(["衬衫", "毛衣", "领带", "裤子", "风衣", "高跟鞋", "袜子"])
#     bar1.add_yaxis("商家A", [114, 55, 27, 101, 125, 27, 105])
#     bar1.add_yaxis("商家B", [57, 134, 137, 129, 145, 60, 49])
#     bar1.add_yaxis("商家C", [57, 134, 137, 129, 145, 60, 49])
#     bar1.set_global_opts(title_opts=opts.TitleOpts(title="某商场销售情况2"))
#     # 将柱状图bar和bar1添加到page页面中，这样就可以将两个图标绘制成一个html中了
    
#     page.add(bar, bar1)
#     page.render("test.html")
#     os.system("test.html")



import itertools

# 所有组合数17721088

# 生成1到34的数字列表
numbers = list(range(1, 34))

# 计算排列组合

combos = itertools.combinations(numbers, 6)
i = 0
# 1-33 的数字中，任取6个数字的排列组合数为：C(33,6) = 33! / (6! * (33-6)!) = 5,005,520
# 将计算记过保存到txt文本中
with open('combos.txt', 'w') as f:
    for combo in combos:
        f.write(','.join(str(num) for num in combo) + '\n')
print('Done!')