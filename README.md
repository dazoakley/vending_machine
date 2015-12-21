# Vending machine

A coding test...

## The Challenge

Design a vending machine in code. The vending machine should perform as follows:

* Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product.
* It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted.
* The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
* There should be a way of reloading either products or change at a later point.
* The machine should keep track of the products and change that it contains.

Please develop the machine in any language you are comfortable although Ruby would be preferred.

## Notes

I've written an OO model for a vending machine, it's basic but it's a start.  Things that are missing or could do with some work...

* A command-line or web interface to drive things - this is just the model.
* I'm not 100% happy with the product/product_shelf arrangement.  If I was to do this again I would model the quantity and price of products in the same place, as with this model you could have identical product (names), but with different prices.
