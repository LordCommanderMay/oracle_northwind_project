create sequence SEQ_NW_CATEGORIES
    nocache
/

create sequence SEQ_NW_CUSTOMERS
    nocache
/

create sequence SEQ_NW_EMPLOYEES
    nocache
/

create sequence SEQ_NW_SUPPLIERS
    nocache
/

create sequence SEQ_NW_SHIPPERS
    nocache
/

create sequence SEQ_NW_PRODUCTS
    nocache
/

create sequence SEQ_NW_ORDERS
    nocache
/

create table CATEGORIES
(
    CATEGORY_ID   NUMBER(9)    not null
        constraint PK_CATEGORIES
            primary key,
    CATEGORY_NAME VARCHAR2(15) not null,
    DESCRIPTION   VARCHAR2(2000),
    PICTURE       VARCHAR2(255)
)
/

comment on column CATEGORIES.CATEGORY_ID is 'Number automatically assigned to a new category.'
/

comment on column CATEGORIES.CATEGORY_NAME is 'Name of food category.'
/

comment on column CATEGORIES.PICTURE is 'A picture representing the food category.'
/

create unique index UIDX_CATEGORY_NAME
    on CATEGORIES (CATEGORY_NAME)
/

create table CUSTOMERS
(
    CUSTOMER_ID   NUMBER(9)    not null
        constraint PK_CUSTOMERS
            primary key,
    CUSTOMER_CODE VARCHAR2(5)  not null,
    COMPANY_NAME  VARCHAR2(40) not null,
    CONTACT_NAME  VARCHAR2(30),
    CONTACT_TITLE VARCHAR2(30),
    ADDRESS       VARCHAR2(60),
    CITY          VARCHAR2(15),
    REGION        VARCHAR2(15),
    POSTAL_CODE   VARCHAR2(10),
    COUNTRY       VARCHAR2(15),
    PHONE         VARCHAR2(24),
    FAX           VARCHAR2(24)
)
/

comment on column CUSTOMERS.CUSTOMER_ID is 'Unique five-character code based on customer name.'
/

comment on column CUSTOMERS.ADDRESS is 'Street or post-office box.'
/

comment on column CUSTOMERS.REGION is 'State or province.'
/

comment on column CUSTOMERS.PHONE is 'Phone number includes country code or area code.'
/

comment on column CUSTOMERS.FAX is 'Phone number includes country code or area code.'
/

create unique index UIDX_CUSTOMERS_CODE
    on CUSTOMERS (CUSTOMER_CODE)
/

create index IDX_CUSTOMERS_CITY
    on CUSTOMERS (CITY)
/

create index IDX_CUSTOMERS_COMPANY_NAME
    on CUSTOMERS (COMPANY_NAME)
/

create index IDX_CUSTOMERS_POSTAL_CODE
    on CUSTOMERS (POSTAL_CODE)
/

create index IDX_CUSTOMERS_REGION
    on CUSTOMERS (REGION)
/

create table EMPLOYEES
(
    EMPLOYEE_ID       NUMBER(9)    not null
        constraint PK_EMPLOYEES
            primary key,
    LASTNAME          VARCHAR2(20) not null,
    FIRSTNAME         VARCHAR2(10) not null,
    TITLE             VARCHAR2(30),
    TITLE_OF_COURTESY VARCHAR2(25),
    BIRTHDATE         DATE,
    HIREDATE          DATE,
    ADDRESS           VARCHAR2(60),
    CITY              VARCHAR2(15),
    REGION            VARCHAR2(15),
    POSTAL_CODE       VARCHAR2(10),
    COUNTRY           VARCHAR2(15),
    "Phone_Number"    VARCHAR2(24),
    EXTENSION         VARCHAR2(4),
    PHOTO             VARCHAR2(255),
    NOTES             VARCHAR2(2000),
    REPORTS_TO        NUMBER(9)
        constraint FK_REPORTS_TO
            references EMPLOYEES
)
/

comment on column EMPLOYEES.EMPLOYEE_ID is 'Number automatically assigned to new employee.'
/

comment on column EMPLOYEES.TITLE is 'Employee''s title.'
/

comment on column EMPLOYEES.TITLE_OF_COURTESY is 'Title used in salutations.'
/

comment on column EMPLOYEES.ADDRESS is 'Street or post-office box.'
/

comment on column EMPLOYEES.REGION is 'State or province.'
/

comment on column EMPLOYEES."Phone_Number" is 'Phone number includes country code or area code.'
/

comment on column EMPLOYEES.EXTENSION is 'Internal telephone extension number.'
/

comment on column EMPLOYEES.PHOTO is 'Picture of employee.'
/

comment on column EMPLOYEES.NOTES is 'General information about employee''s background.'
/

comment on column EMPLOYEES.REPORTS_TO is 'Employee''s supervisor.'
/

create index IDX_EMPLOYEES_LASTNAME
    on EMPLOYEES (LASTNAME)
/

create index IDX_EMPLOYEES_POSTAL_CODE
    on EMPLOYEES (POSTAL_CODE)
/

create trigger TRG_EMP_BIRTHDATE
    before insert or update
    on EMPLOYEES
    for each row
begin
    if :New.birthdate > trunc(sysdate) then
          RAISE_APPLICATION_ERROR (num => -20000, msg => 'Birthdate cannot be in the future');
    end if;
end;
/

create table SUPPLIERS
(
    SUPPLIER_ID   NUMBER(9)    not null
        constraint PK_SUPPLIERS
            primary key,
    COMPANY_NAME  VARCHAR2(40) not null,
    CONTACT_NAME  VARCHAR2(30),
    CONTACT_TITLE VARCHAR2(30),
    ADDRESS       VARCHAR2(60),
    CITY          VARCHAR2(15),
    REGION        VARCHAR2(15),
    POSTAL_CODE   VARCHAR2(10),
    COUNTRY       VARCHAR2(15),
    PHONE         VARCHAR2(24),
    FAX           VARCHAR2(24),
    HOME_PAGE     VARCHAR2(500)
)
/

comment on column SUPPLIERS.SUPPLIER_ID is 'Number automatically assigned to new supplier.'
/

comment on column SUPPLIERS.ADDRESS is 'Street or post-office box.'
/

comment on column SUPPLIERS.REGION is 'State or province.'
/

comment on column SUPPLIERS.PHONE is 'Phone number includes country code or area code.'
/

comment on column SUPPLIERS.FAX is 'Phone number includes country code or area code.'
/

comment on column SUPPLIERS.HOME_PAGE is 'Supplier''s home page on World Wide Web.'
/

create index IDX_SUPPLIERS_COMPANY_NAME
    on SUPPLIERS (COMPANY_NAME)
/

create index IDX_SUPPLIERS_POSTAL_CODE
    on SUPPLIERS (POSTAL_CODE)
/

create table SHIPPERS
(
    SHIPPER_ID   NUMBER(9)    not null
        constraint PK_SHIPPERS
            primary key,
    COMPANY_NAME VARCHAR2(40) not null,
    PHONE        VARCHAR2(24)
)
/

comment on column SHIPPERS.SHIPPER_ID is 'Number automatically assigned to new shipper.'
/

comment on column SHIPPERS.COMPANY_NAME is 'Name of shipping company.'
/

comment on column SHIPPERS.PHONE is 'Phone number includes country code or area code.'
/

create table PRODUCTS
(
    PRODUCT_ID        NUMBER(9)                 not null
        constraint PK_PRODUCTS
            primary key,
    PRODUCT_NAME      VARCHAR2(40)              not null,
    SUPPLIER_ID       NUMBER(9)                 not null
        constraint FK_SUPPLIER_ID
            references SUPPLIERS,
    CATEGORY_ID       NUMBER(9)                 not null
        constraint FK_CATEGORY_ID
            references CATEGORIES,
    QUANTITY_PER_UNIT VARCHAR2(20),
    UNIT_PRICE        NUMBER(10, 2) default 0   not null
        constraint CK_PRODUCTS_UNIT_PRICE
            check (Unit_Price >= 0),
    UNITS_IN_STOCK    NUMBER(9)     default 0   not null
        constraint CK_PRODUCTS_UNITS_IN_STOCK
            check (Units_In_Stock >= 0),
    UNITS_ON_ORDER    NUMBER(9)     default 0   not null
        constraint CK_PRODUCTS_UNITS_ON_ORDER
            check (Units_On_Order >= 0),
    REORDER_LEVEL     NUMBER(9)     default 0   not null
        constraint CK_PRODUCTS_REORDER_LEVEL
            check (Reorder_Level >= 0),
    DISCONTINUED      CHAR          default 'N' not null
        constraint CK_PRODUCTS_DISCONTINUED
            check (Discontinued in ('Y', 'N'))
)
/

comment on column PRODUCTS.PRODUCT_ID is 'Number automatically assigned to new product.'
/

comment on column PRODUCTS.SUPPLIER_ID is 'Same entry as in Suppliers table.'
/

comment on column PRODUCTS.CATEGORY_ID is 'Same entry as in Categories table.'
/

comment on column PRODUCTS.QUANTITY_PER_UNIT is '(e.g., 24-count case, 1-liter bottle).'
/

comment on column PRODUCTS.REORDER_LEVEL is 'Minimum units to maintain in stock.'
/

comment on column PRODUCTS.DISCONTINUED is 'Yes means item is no longer available.'
/

create index IDX_PRODUCTS_CATEGORY_ID
    on PRODUCTS (CATEGORY_ID)
/

create index IDX_PRODUCTS_SUPPLIER_ID
    on PRODUCTS (SUPPLIER_ID)
/

create table ORDERS
(
    ORDER_ID         NUMBER(9) not null
        constraint PK_ORDERS
            primary key,
    CUSTOMER_ID      NUMBER(9) not null
        constraint FK_CUSTOMER_ID
            references CUSTOMERS,
    EMPLOYEE_ID      NUMBER(9) not null
        constraint FK_EMPLOYEE_ID
            references EMPLOYEES,
    ORDER_DATE       DATE      not null,
    REQUIRED_DATE    DATE,
    SHIPPED_DATE     DATE,
    SHIP_VIA         NUMBER(9)
        constraint FK_SHIPPER_ID
            references SHIPPERS,
    FREIGHT          NUMBER(10, 2) default 0,
    SHIP_NAME        VARCHAR2(40),
    SHIP_ADDRESS     VARCHAR2(60),
    SHIP_CITY        VARCHAR2(15),
    SHIP_REGION      VARCHAR2(15),
    SHIP_POSTAL_CODE VARCHAR2(10),
    SHIP_COUNTRY     VARCHAR2(15)
)
/

comment on column ORDERS.ORDER_ID is 'Unique order number.'
/

comment on column ORDERS.CUSTOMER_ID is 'Same entry as in Customers table.'
/

comment on column ORDERS.EMPLOYEE_ID is 'Same entry as in Employees table.'
/

comment on column ORDERS.SHIP_VIA is 'Same as Shipper ID in Shippers table.'
/

comment on column ORDERS.COMPANY_NAME is 'Name of person or company to receive the shipment.'
/

comment on column ORDERS.SHIP_ADDRESS is 'Street address only -- no post-office box allowed.'
/

comment on column ORDERS.SHIP_REGION is 'State or province.'
/

create index IDX_ORDERS_CUSTOMER_ID
    on ORDERS (CUSTOMER_ID)
/

create index IDX_ORDERS_EMPLOYEE_ID
    on ORDERS (EMPLOYEE_ID)
/

create index IDX_ORDERS_SHIPPER_ID
    on ORDERS (SHIP_VIA)
/

create index IDX_ORDERS_ORDER_DATE
    on ORDERS (ORDER_DATE)
/

create index IDX_ORDERS_SHIPPED_DATE
    on ORDERS (SHIPPED_DATE)
/

create index IDX_ORDERS_SHIP_POSTAL_CODE
    on ORDERS (SHIP_POSTAL_CODE)
/

create table ORDER_DETAILS
(
    ORDER_ID   NUMBER(9)               not null
        constraint FK_ORDER_ID
            references ORDERS,
    PRODUCT_ID NUMBER(9)               not null
        constraint FK_PRODUCT_ID
            references PRODUCTS,
    UNIT_PRICE NUMBER(10, 2) default 0 not null
        constraint CK_ORDER_DETAILS_UNIT_PRICE
            check (Unit_Price >= 0),
    QUANTITY   NUMBER(9)     default 1 not null
        constraint CK_ORDER_DETAILS_QUANTITY
            check (Quantity > 0),
    DISCOUNT   NUMBER(4, 2)  default 0 not null
        constraint CK_ORDER_DETAILS_DISCOUNT
            check (Discount between 0 and 1),
    constraint PK_ORDER_DETAILS
        primary key (ORDER_ID, PRODUCT_ID)
)
/

comment on column ORDER_DETAILS.ORDER_ID is 'Same as Order ID in Orders table.'
/

comment on column ORDER_DETAILS.PRODUCT_ID is 'Same as Product ID in Products table.'
/

create index IDX_ORDER_DETAILS_ORDER_ID
    on ORDER_DETAILS (ORDER_ID)
/

create index IDX_ORDER_DETAILS_PRODUCT_ID
    on ORDER_DETAILS (PRODUCT_ID)
/


