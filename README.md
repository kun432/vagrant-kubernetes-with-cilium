# vagrant-kubernetes-with-cilium

vagrantでCNIにCiliumを使ったkubernetesクラスタを作成します。

- kubernetesクラスタ
  - master x 1
  - worker x 2

## 必要なもの

- Vagrant

```
$ brew cask install vagrant virtualbox virtualbox-extension-pack
```

## 使い方

```
$ git clone https://github.com/kun432/vagrant-kubernetes-with-cilium.git
$ vagrant up
```
