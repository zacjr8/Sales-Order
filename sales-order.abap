REPORT z_auto_sales_order.

DATA: lv_customer TYPE kna1-kunnr,
      lv_product  TYPE mara-matnr,
      lv_quantity TYPE vbap-quantity,
      lv_price    TYPE vbap-netwr.

* Input data (replace with actual data retrieval logic)
lv_customer = 'CUSTOMER123'.
lv_product  = 'PRODUCT456'.
lv_quantity = 10.

* Validate customer data (check if the customer exists)
SELECT SINGLE name1
  INTO lv_customer
  FROM kna1
  WHERE kunnr = lv_customer.

IF sy-subrc <> 0.
  WRITE: 'Customer not found.'.
  EXIT.
ENDIF.

* Check product availability (check if the product exists)
SELECT SINGLE maktx
  INTO lv_product
  FROM mara
  WHERE matnr = lv_product.

IF sy-subrc <> 0.
  WRITE: 'Product not found.'.
  EXIT.
ENDIF.

* Pricing calculation (replace with actual pricing logic)
lv_price = lv_quantity * 100.  "Example pricing logic

* Create the sales order
DATA: lt_items TYPE TABLE OF bapivbap,
      ls_item  TYPE bapivbap,
      ls_return TYPE bapiret2.

* Define the sales order header data
DATA: ls_header TYPE bapisdhd1,
      lv_sales_organization TYPE vbak-vkorg.

lv_sales_organization = '1000'.  "Replace with your sales organization

* Fill in the sales order header data
ls_header-salesorg = lv_sales_organization.
ls_header-distr_chan = '01'.     "Distribution channel (replace as needed)
ls_header-division = '00'.      "Division (replace as needed)

* Define the sales order item
CLEAR ls_item.
ls_item-material = lv_product.
ls_item-plant = '1000'.   "Plant code (replace as needed)
ls_item-quantity = lv_quantity.
ls_item-net_value = lv_price.

APPEND ls_item TO lt_items.

* Call BAPI to create the sales order
CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
  EXPORTING
    order_header_in = ls_header
  TABLES
    order_items_in = lt_items
    return = ls_return.

IF ls_return[] IS INITIAL.
  WRITE: 'Sales order created successfully.'.
ELSE.
  WRITE: 'Error while creating the sales order:', ls_return-message.
ENDIF.
