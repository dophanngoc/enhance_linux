### Harden Ubuntu Desktop 20
### Harden CentOS 8

**Instruction**

*Ubuntu*

```
git clone https://github.com/dophanngoc/enhance_linux.git
sudo bash optimize
```

*CentOS*

```
git clone https://github.com/dophanngoc/enhance_linux.git
git checkout centos
sudo bash optimize
```




Run `sudo bash optimize`


**Network traffic monitoring**

- Monitor packet per socket

`sudo iftop -i <if-name>`

- Monitor traffic per app

`sudo nethogs <if-name>`
 
