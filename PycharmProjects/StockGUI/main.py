from tkinter import *
import tkinter as tk

#Data Source
import yfinance as yf

def myClick():
    stock_input = e.get()
    stock = yf.Ticker(stock_input)
    stock_Name = str(stock.info['shortName'])
    stock_price = str(stock.info['regularMarketPrice'])

    lbl.set("Name: " + stock_Name)
    lbl2.set("Previous Close: " + stock_price)

root = tk.Tk()
#root.geometry("700x350")
root.title("Investment")


e = Entry(root, width=35, borderwidth=5)
e.grid(row=0, column=0, columnspan=3,padx=10,pady=10)


myButton = Button(root, text="Enter stock ticker", command=myClick, padx=25)
myButton
myButton.grid()

lbl = tk.StringVar()
lbl2 = tk.StringVar()
lbl.set('Name: ')
lbl2.set('Previous Close: ')
tk.Label(root, textvariable = lbl).grid()
tk.Label(root, textvariable = lbl2).grid()

root.mainloop()
