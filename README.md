etherswitch
===========

etherswitch is a simple daemon to control a toggle switch attached to a router.

How to use it
-------------

* Build opkg package `make ipk`

* Get a router
  * Install OpenWRT
  * Install etherswitch `opkg install etherswitch.ipk`
  * Configure etherswitch
* Get an ethernet cable and a toggle switch
  * Cross RX+ and TX+
  * Attach RX- and TX- to the toggle switch (or viceversa)

![muciaccia](http://i.imgur.com/7qWVZPj.png)

TODO
----

* [x] Make a package for OpenWRT
* [ ] Re-introduce the possibility to use it with physical ethernet interface (without using ip)
* [ ] Write a real readme