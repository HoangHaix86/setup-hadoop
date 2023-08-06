import asyncio
import websockets
from pprint import pprint
import os
import json
from slugify import slugify
import shutil

# class Client:

#     def __init__(self, websocket):
#         self.websocket = websocket
#         pprint(f"Client: {self.websocket}")
#         async for message in self.websocket:
#             print(message)

class Server:
    def __init__(self):
        self.server = None

    async def handler(self, websocket, path):
        # pprint(f"Connected to {path}")
        # pprint(f"Websocket: {websocket}")
        print(websocket)

        try:
            # async for message in websocket:
            #     print(message)
            while 1:
                message = await websocket.recv()
                pprint(message)
                await websocket.send("Hello")
        except websockets.exceptions.ConnectionClosed:
            pprint("Connection closed")
            return

    async def start(self):
        self.server = await websockets.serve(self.handler, "localhost", 8001)
        await self.server.wait_closed()

if __name__ == "__main__":
    asyncio.run(Server().start())