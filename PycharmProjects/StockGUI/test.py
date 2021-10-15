import tkinter as tk
import time


def callback():
    lbl.set('{}'.format(time.time()))


root = tk.Tk()
lbl = tk.StringVar()
lbl.set('default')
tk.Label(root, textvariable=lbl).pack()
tk.Button(root, text="Get Time", command=callback).pack()

root.mainloop()