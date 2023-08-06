from math import sqrt
from pprint import pprint

class MapReduce:
    
    def __init__(self, input_path: str):
        self.input = self.get_input(input_path)
        self.MAP = []
        self.mapper(self.input)
        pprint(self.MAP)
        self.shuffler()
        # pprint(self.MAP)

    def get_input(self, input_path: str):
        with open(input_path, 'r') as f:
            lines = f.readlines()

        new_lines = []

        for line in lines:
            line = line.strip()
            new_lines.append(line)

        return new_lines

    def string_tokenize(self, input: str):
        return input.split()

    def mapper(self, input: str):
        for line in self.input:
            for word in self.string_tokenize(line):
                number = int(word)
                print(f'number: {number}')
                for i in range(2, number + 1):
                    if number % i == 0:
                        print(f'i: {i}')
                        self.MAP.append((number, i))
                        break

    def shuffler(self):
        self.MAP.sort(key=lambda x: x[0])

# def StringTokenize():
#     return input.split()

# def Mapper(input):
#     for word in StringTokenize(input):
#         print(word, 1)

# def Shuffler(input):
#     pass

if __name__ == '__main__':
    MapReduce(input_path='./input.txt')