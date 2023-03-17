import base64
import yaml
import json



def dealData(str):
    vmess_str = str
    if(len(vmess_str)%3 == 1): 
        vmess_str += "=="
    elif(len(vmess_str)%3 == 2): 
        vmess_str += "=" 

    vmess_data = {}
    vmess_parts = vmess_str.split("://")[1]
    vmess_base64 = vmess_parts.strip()

    vmess_decoded = base64.b64decode(vmess_base64).decode("utf-8")
    vmess_data = json.loads(vmess_decoded)

    clashx_data = {
        "name": vmess_data["ps"],
        "type": "vmess",
        "server": vmess_data["add"],
        "port": int(vmess_data["port"]),
        "uuid": vmess_data["id"],
        "alterId": int(vmess_data["aid"]),
        "cipher": vmess_data["type"],
        "tls": True if vmess_data["tls"] == "tls" else False
    }
    print(clashx_data["name"])
    yaml_data = yaml.dump(clashx_data, default_flow_style=False)
    print("")
    print(yaml_data)




# input vmess content 
vmess_str = """vmess://base64Content"""
vmessArr = vmess_str.split("\n")

print(vmessArr)
for str in vmessArr:
    dealData(str)
