import asyncio
import websockets
from pprint import pprint
import os
import json
from slugify import slugify
import shutil

class Server:
    def __init__(self):
        self.vms = {}
        self.path = r'C:\Users\HoangHai\Documents\Virtual Machines'

    async def send(self, websocket, data):
        await websocket.send(json.dumps(data))

    async def get_folder(self, websocket):
        try:
            while True:
                data = {
                    "type": "GET",
                    "data": {}
                }
                d = os.listdir(self.path)
                for i in d:
                    self.vms.update({slugify(i): i})
                
                await self.send(websocket, json.dumps(data))
                await asyncio.sleep(3)
        except websockets.exceptions.ConnectionClosed:
            print("Connection closed")
            return

    async def delete_folder(self, websocket, vm):
        shutil.rmtree(f'{self.path}\\{self.vms[vm]}')
        del self.vms[vm]
        data = {
            "type": "DELETE",
            "data": {},
            "message": "Deleted"
        }
        await self.send(websocket, json.dumps(data))


    async def handler(self, websocket):
        async for message in websocket:
            data = json.loads(message)
            if data['type'] == "GET":
                await self.get_folder(websocket)
                return
            if data['type'] == "DELETE":
                await self.delete_folder(websocket, data['vm'])
                return
        
            
    
    def start(self):
        start_server = websockets.serve(self.handler, "localhost", 8765)
        asyncio.get_event_loop().run_until_complete(start_server)
        asyncio.get_event_loop().run_forever()
        
        
Server().start()