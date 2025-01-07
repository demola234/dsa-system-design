def get_name(bool):
    if bool:
        return "Hello World"
    else:
        return "Wrong"

name = get_name(False)
print(name)