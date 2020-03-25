# Snell Docker

此Docker镜像由Xavier Niu维护。

基于

- snell: 2.0.0-b9
- alpine: 3.11

## 运行

使用docker运行

```bash
docker run -d \
  --name snell \
  -e PSK=<PSK> \
  -e PORT=<PORT> \
  -e OBFS=<OBFS> \
  -p 8388:8388 \ 
  --restart=unless-stopped \
  xavierniu/snell
```

环境变量

- `<PSK>`: [required]密码
- `<PORT>`: [optional]端口，默认`8388`
- `<OBFS>`: [optional]混淆方式，默认`tls`

## 有疑问？

如果有任何问题可以在GitHub中创建一个新的issue或者通过邮件`a#nxw.name`与我取得联系。