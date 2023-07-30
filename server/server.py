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
        json_string = json.dumps(data)
        await websocket.send(json_string)

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
                data['data'] = self.vms
                
                await self.send(websocket, data)
                await asyncio.sleep(3)
            
        except websockets.exceptions.ConnectionClosed:
            print("Connection closed")
            return

    async def delete_folder(self, websocket, vm):
        pprint(vm)
        shutil.rmtree(f'{self.path}\\{self.vms[vm]}')
        del self.vms[vm]
        data = {
            "type": "DEl",
            "data": {},
            "message": "Deleted"
        }
        await self.send(websocket, data)


    async def handler(self, websocket):
        pprint(websocket)
        async for message in websocket:
            data = json.loads(message)
            pprint(data)
            if data['type'] == "GET":
                self.get_folder(websocket)
                return
            if data['type'] == "DEL":
                self.delete_folder(websocket, data['vm'])
                return
        
            
    
    def start(self):
        start_server = websockets.serve(self.handler, "localhost", 8765)
        asyncio.get_event_loop().run_until_complete(start_server)
        asyncio.get_event_loop().run_forever()
        
        
Server().start()