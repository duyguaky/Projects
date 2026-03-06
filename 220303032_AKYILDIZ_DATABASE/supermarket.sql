
create table branch (
	 branch_id  int auto_increment primary key,
     branch_name varchar(100) not null,
     city varchar(100) not null,
     district varchar(100) not null,
     address varchar(200) not null,
     phone varchar(20),
     status enum('active','closed') default 'active'
);

CREATE TABLE branch_stock (
    branch_id INT NOT NULL,
    product_id INT NOT NULL,
    stock_quantity DECIMAL(12,3) NOT NULL,
    PRIMARY KEY (branch_id, product_id)
);
CREATE TABLE branch_product_stock (
    branch_id INT NOT NULL,
    product_id INT NOT NULL,
    stock_quantity DECIMAL(12,3) NOT NULL DEFAULT 0,
    PRIMARY KEY (branch_id, product_id),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);


create table category (
	 category_id int auto_increment primary key,
     category_name varchar(100) not null,
     parent_category_id int
);

create table supplier (
     supplier_id int auto_increment primary key,
     supplier_name varchar(150) not null,
     contact_person varchar(100),
     phone varchar(30),
     email varchar(120),
     address varchar(255),
     supplier_type varchar(20)
);
     
create table customer (
    customer_id int auto_increment primary key,
    first_name varchar(80) not null,
    last_name varchar(80) not null,
    gender varchar(10),
    birth_date date,
    email varchar(120),
    phone varchar(30),
    city varchar(100),
    district varchar(100),
    address varchar(255),
    registration_date date not null
);

create table product (
    product_id int auto_increment primary key,
    category_id int not null,
    barcode varchar(64) not null unique,
    brand varchar(100),
    unit varchar(30),
    unit_price decimal(12,2) not null,
    tax_rate decimal(4,2),
    stock_quantity int,
    production_date date,
    expiry_date date
);

create table sale (
    sale_id int auto_increment primary key,
    branch_id int not null,
    customer_id int,
    sale_datetime datetime not null,
    payment_method varchar(20) not null,
    receipt_number varchar(64) not null unique,
    subtotal decimal(12,2) not null,
    discount_amount decimal(12,2) not null,
    tax_amount decimal(12,2) not null,
    total_amount decimal(12,2) not null
);



create table sale_item (
    sale_id int not null,
    product_id int not null,
    quantity decimal(12,3) not null,
    unit_price decimal(12,2) not null,
    tax_rate decimal(4,2),
    discount_rate decimal(4,2),
    
    primary key (sale_id, product_id)
    );
    
create table supplies (
    supply_id int auto_increment primary key,
    branch_id int not null,
    supplier_id int not null,
    product_id int not null,
    supply_datetime datetime not null,
    quantity decimal(12,3) not null,
    supply_price decimal(12,2) not null,
    batch_no varchar(64),
    production_date date,
    expiry_date date
);

create table inventory_movement (
    movement_id int auto_increment primary key,
    branch_id int not null,
    product_id int not null,
    movement_datetime datetime not null,
    movement_type varchar(20) not null,
    source_type varchar(20) not null,
    source_ref varchar(64),
    quantity decimal(12,3) not null,
    unit_cost decimal(12,2)
);


alter table category
add constraint fk_category_parent
foreign key (parent_category_id)
references category(category_id)
on delete set null
on update cascade;

alter table product
add constraint fk_product_category
foreign key (category_id)
references category(category_id)
on delete restrict
on update cascade;
alter table product
add column package_size decimal(10,2) not null default 1,
add column package_unit varchar(10) not null default 'ADET';
alter table product
add column product_name varchar(150) null;

alter table sale
add constraint fk_sale_branch
foreign key (branch_id)
references branch(branch_id)
on delete restrict
on update cascade;
alter table sale
add constraint fk_sale_customer
foreign key (customer_id)
references customer(customer_id)
on delete set null
on update cascade;

alter table sale_item
add constraint fk_sale_item_sale
foreign key (sale_id)
references sale(sale_id)
on delete cascade
on update cascade;
alter table sale_item
add constraint fk_sale_item_product
foreign key (product_id)
references product(product_id)

on delete restrict
on update cascade;
ALTER TABLE sale_item
ADD COLUMN branch_id INT NOT NULL;


alter table supplies
add constraint fk_supplies_branch
foreign key (branch_id)
references branch(branch_id)
on delete restrict
on update cascade;
alter table supplies
add constraint fk_supplies_supplier
foreign key (supplier_id)
references supplier(supplier_id)
on delete restrict
on update cascade;
alter table supplies
add constraint fk_supplies_product
foreign key (product_id)
references product(product_id)
on delete restrict
on update cascade;

alter table inventory_movement
add constraint fk_inv_move_branch
foreign key (branch_id)
references branch(branch_id)
on delete restrict
on update cascade;
alter table inventory_movement
add constraint fk_inv_move_product
foreign key (product_id)
references product(product_id)
on delete restrict
on update cascade;

alter table product
add column min_age int default 0;

INSERT INTO branch_product_stock (branch_id, product_id, stock_quantity)
SELECT
    b.branch_id,
    p.product_id,
    ROUND(p.stock_quantity / 5, 3)
FROM product p
JOIN branch b
WHERE p.stock_quantity IS NOT NULL;

INSERT INTO branch_product_stock (branch_id, product_id, stock_quantity)
SELECT
    b.branch_id,
    p.product_id,
    0
FROM branch b
JOIN product p
LEFT JOIN branch_product_stock bps
  ON bps.branch_id = b.branch_id
 AND bps.product_id = p.product_id
WHERE bps.product_id IS NULL;

ALTER TABLE branch_product_stock
MODIFY stock_quantity INT NOT NULL;


insert into branch (branch_name, city, district, address, phone, status)
values
('Merkez Şube', 'İstanbul', 'Bahçelievler', 'Adnan Kahveci Bulvarı No: 120', '0212 555 10 10', 'active'),
('Kadıköy Şubesi', 'İstanbul', 'Kadıköy', 'Bağdat Caddesi No: 85', '0216 555 20 20', 'active'),
('Sarıyer Şubesi', 'İstanbul', 'Sarıyer', 'Büyükdere Caddesi No: 140', '0212 555 25 25', 'active'),
('Ankara Şubesi', 'Ankara', 'Çankaya', 'Atatürk Bulvarı No: 60', '0312 555 30 30', 'active'),
('İzmir Şubesi', 'İzmir', 'Konak', 'Gazi Bulvarı No: 45', '0232 555 40 40', 'active');

insert into category (category_name, parent_category_id)
values
('meyve - sebze', null),
('et - tavuk - balık', null),
('süt - kahvaltılık', null),
('temel gıda', null),
('içecek', null),
('atıştırmalık', null),
('dondurma', null),
('fırın - pastane', null),
('meze - hazır yemek - donuk', null),
('deterjan - temizlik', null),
('alkol', null),
('sigara - tütün', null);


insert into category (category_name, parent_category_id) values
-- 1) meyve - sebze
('meyve', 1),
('sebze', 1),
-- 2) et - tavuk - balık
('kırmızı et', 2),
('beyaz et', 2),
('balık - deniz ürünleri', 2),
('et şarküteri', 2),
-- 3) süt - kahvaltılık
('süt', 3),
('peynir', 3),
('yoğurt', 3),
('tereyağı', 3),
('margarin', 3),
('yumurta', 3),
('zeytin', 3),
('krema', 3),
('kahvaltılıklar', 3),
-- 4) temel gıda
('makarnalar', 4),
('bakliyat', 4),
('sıvı yağ', 4),
('tuz - baharat', 4),
('bulyon', 4),
('konserve', 4),
('sos', 4),
('un', 4),
('şeker', 4),
-- 5) içecek
('gazlı içecek', 5),
('gazsız içecek', 5),
('çay', 5),
('kahve', 5),
('su', 5),
('maden suyu', 5),
-- 6) atıştırmalık
('kuru meyve', 6),
('kuruyemiş', 6),
('cips', 6),
('çikolata', 6),
('gofret', 6),
('bar - kaplamalılar', 6),
('bisküvi', 6),
('kek', 6),
('kraker', 6),
('mısır ve pirinç patlağı', 6),
('şekerleme', 6),
('sakız', 6),
-- 7) dondurma (alt kategori yok)
-- 8) fırın - pastane
('ekmek', 8),
('hamur - pasta malzemeleri', 8),
-- 9) hazır yemek - donuk
('paketli sandviç', 9),
('dondurulmuş gıda', 9),
-- 10) deterjan - temizlik
('genel temizlik', 10),
('çamaşır yıkama', 10),
('bulaşık yıkama', 10),
('temizlik malzemeleri', 10),
('çöp poşeti', 10);
insert into category (category_name, parent_category_id)
values
-- alkol
('bira', 83),
('şarap', 83),
('viski', 83),
('votka', 83),
-- sigara - tütün
('sigara', 84);

insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
-- meyve-sebze
('özdemir meyve sebze ltd.', 'hüseyin özdemir', '0212 700 1001', 'info@ozdemirms.com', 'istanbul – hal', 'meyve – sebze'),
('yeşilbahçe gıda tedarik', 'ahmet yıldız', '0212 700 1002', 'satis@yesilbahce.com', 'istanbul – bayrampaşa','meyve – sebze'),
('ankara hal meyve sebze', 'murat arslan', '0312 400 2001', 'info@ankarameyve.com', 'ankara – ostim', 'meyve – sebze'),
('ege taze meyve dağıtım', 'burcu deniz', '0232 500 3001', 'info@egetazemeyve.com', 'izmir – karşıyaka', 'meyve – sebze'),
('antgıda sebze tedarik', 'ismail duman', '0242 300 4001', 'info@antgida.com', 'antalya – hal', 'meyve – sebze'),
('karadeniz taze ürünler', 'metin çelik', '0462 600 5001', 'info@karadeniztaze.com', 'trabzon – merkez', 'meyve – sebze');
-- et-tavuk-balik
insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
('Banvit', 'Murat Öztürk', '0262 676 1010', 'info@banvit.com', 'Bandırma', 'et – tavuk – balık'),
('Beypiliç', 'Ahmet Güler', '0374 228 2020', 'info@beypilic.com', 'Bolu', 'et – tavuk – balık'),
('Namet', 'Serkan Kaya', '0262 646 3030', 'info@namet.com.tr', 'Kocaeli', 'et – tavuk – balık'),
('Pınar', 'Levent Yıldız', '0232 482 2200', 'info@pinar.com.tr', 'İzmir', 'et – tavuk – balık'),
('Keskinoğlu', 'Cemal Yetkin', '0236 233 4040', 'info@keskinoglu.com.tr', 'Manisa', 'et – tavuk – balık'),
('Polonez', 'Onur Sarı', '0216 504 5050', 'info@polonez.com.tr', 'İstanbul', 'et – tavuk – balık'),
('Uzman Kasap', 'Erdem Şen', '0212 345 6060', 'uzman@sokmarket.com', 'İstanbul', 'et – tavuk – balık'),
('Torku', 'Cihat Kar', '0332 221 1111', 'info@torku.com.tr', 'Konya', 'et – tavuk – balık'),
('Lezita', 'Suat Deniz', '0232 878 7070', 'info@lezita.com', 'İzmir Kemalpaşa', 'et – tavuk – balık'),
('Dardanel', 'Erkan Uçar', '0286 217 0202', 'info@dardanel.com.tr', 'Çanakkale', 'et – tavuk – balık'),
('İstanbul Balık Hali', 'Hakan Yılmaz', '0212 560 3030', 'info@istanbulbalik.com', 'İstanbul – Kumkapı', 'et – tavuk – balık'),
('Karadeniz Deniz Ürünleri', 'Yaşar Demir', '0462 444 9090', 'info@karadenizsea.com', 'Trabzon', 'et – tavuk – balık'),
('Kuruçeşme Kasap', 'Mete Yalçın', '0212 445 5050', 'satis@kurucesmekasap.com','İstanbul – Beşiktaş','et – tavuk – balık'),
('Ege Et Dağıtım', 'Serdar Ay', '0232 340 3030', 'info@egeet.com', 'İzmir', 'et – tavuk – balık');
-- süt-kahvaltilik
insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
('Keskinoğlu', 'Mehmet Kaya', '0236 441 1001', 'info@keskinoglu.com', 'Manisa', 'süt – kahvaltılık'),
('Altınkılıç', 'Ahmet Şen', '0262 321 2002', 'info@altinkilic.com', 'Kocaeli', 'süt – kahvaltılık'),
('SEK', 'Cem Durmaz', '0216 541 3003', 'info@sek.com.tr', 'İstanbul', 'süt – kahvaltılık'),
('Sütaş', 'Hülya Demir', '0262 444 4004', 'info@sutas.com', 'Bursa', 'süt – kahvaltılık'),
('İçim', 'Esra Aydın', '0212 555 5005', 'info@icim.com.tr', 'İstanbul', 'süt – kahvaltılık'),
('Torku', 'Erdal Kar', '0332 222 6006', 'info@torku.com.tr', 'Konya', 'süt – kahvaltılık'),
('Pınar', 'Levent Öz', '0232 482 7007', 'info@pinar.com.tr', 'İzmir', 'süt – kahvaltılık'),
('Mlife Yumurta', 'Serkan Polat', '0312 321 8008', 'info@mlife.com', 'Ankara', 'süt – kahvaltılık'),
('Bahçıvan', 'Deniz Koç', '0262 333 9009', 'info@bahcivan.com', 'İstanbul', 'süt – kahvaltılık'),
('Nutella', 'Burak Yılmaz', '0212 555 1010', 'info@nutella.com', 'İstanbul', 'süt – kahvaltılık'),
('Sarelle', 'Duygu Er', '0264 222 1111', 'info@sarelle.com', 'Sakarya', 'süt – kahvaltılık'),
('Tahsildaroğlu', 'Fatih Ak', '0266 331 1212', 'info@tahsildaroglu.com', 'Balıkesir', 'süt – kahvaltılık'),
('Eker', 'Çağla Yurt', '0224 444 1313', 'info@eker.com.tr', 'Bursa', 'süt – kahvaltılık'),
('Ülker', 'Melisa Öz', '0212 555 1414', 'info@ulker.com.tr', 'İstanbul', 'süt – kahvaltılık'),
('Eti', 'Zeynep Baş', '0222 444 1515', 'info@eti.com.tr', 'Eskişehir', 'süt – kahvaltılık'),
('Activia', 'Büşra Ekin', '0216 333 1616', 'info@activia.com', 'İstanbul', 'süt – kahvaltılık'),
('Züber', 'Serkan Can', '0212 555 1717', 'info@zuber.com.tr', 'İstanbul', 'süt – kahvaltılık'),
('Muratbey', 'Hakan Er', '0212 888 1818', 'info@muratbey.com.tr', 'İstanbul', 'süt – kahvaltılık'),
('Tikveşli', 'Tuna Diker', '0216 770 1919', 'info@tikvesli.com', 'İstanbul', 'süt – kahvaltılık'),
('Balparmak', 'Nazan Erkan', '0216 444 2020', 'info@balparmak.com', 'İstanbul', 'süt – kahvaltılık'),
('Ekici', 'Ayhan Uzun', '0242 555 2121', 'info@ekici.com.tr', 'Antalya', 'süt – kahvaltılık'),
('Becel', 'Ecem Kurt', '0212 555 2222', 'info@becel.com.tr', 'İstanbul', 'süt – kahvaltılık'),
('Tamek', 'Volkan Aş', '0262 555 2323', 'info@tamek.com.tr', 'Kocaeli', 'süt – kahvaltılık'),
('Nestle', 'Arda Çınar', '0212 444 2424', 'info@nestle.com', 'İstanbul', 'süt – kahvaltılık'),
('Marmarabirlik', 'Şahin Demir', '0224 555 2525', 'info@marmarabirlik.com', 'Bursa', 'süt – kahvaltılık'),
('Lio Zeytin', 'Turgay Kay', '0232 555 2626', 'info@liozeytin.com', 'İzmir', 'süt – kahvaltılık');
-- temel gida
insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
('Filiz Makarna', 'Mehmet Çelik', '0212 500 1001', 'info@filiz.com', 'İstanbul', 'temel gıda'),
('Barilla', 'Ahmet Can', '0212 500 1002', 'info@barilla.com', 'İstanbul', 'temel gıda'),
('Ankara Makarna', 'Selim Koç', '0312 555 2001', 'info@ankaramakarna.com','Ankara', 'temel gıda'),
('Mutlu Makarna', 'Murat Güler', '0332 444 3001', 'info@mutlu.com', 'Konya', 'temel gıda'),
('Yayla', 'Cem Öz', '0312 555 4001', 'info@yaylabakliyat.com','Ankara', 'temel gıda'),
('Reis', 'Fikret Yalçın', '0212 500 5002', 'info@reis.com.tr', 'İstanbul', 'temel gıda'),
('Tat', 'Zeynep Ar', '0262 555 6003', 'info@tat.com.tr', 'Kocaeli', 'temel gıda'),
('Hasata', 'Sinan Bay', '0312 555 7004', 'info@hasata.com', 'Ankara', 'temel gıda'),
('Duru', 'Hakan Demir', '0332 555 8005', 'info@durubakliyat.com', 'Konya', 'temel gıda'),
('Yudum', 'Fadime Kurt', '0212 555 9006', 'info@yudum.com', 'İstanbul', 'temel gıda'),
('Komili', 'Cem Aydın', '0262 666 0101', 'info@komili.com.tr', 'Yalova', 'temel gıda'),
('Billur Tuz', 'Mustafa Taş', '0232 666 0202', 'info@billurtuz.com', 'İzmir', 'temel gıda'),
('Bağdat Baharat', 'Ali Soy', '0212 666 0303', 'info@bagdatbaharat.com','İstanbul', 'temel gıda'),
('Knorr', 'Elif Ak', '0212 666 0404', 'info@knorr.com', 'İstanbul', 'temel gıda'),
('Efsina', 'Melisa Korkmaz', '0312 666 0505', 'info@efsina.com', 'Ankara', 'temel gıda'),
('Fide', 'Tuba Er', '0312 666 0606', 'info@fide.com', 'Ankara', 'temel gıda'),
('Tamek', 'Volkan Aş', '0262 666 0707', 'info@tamek.com', 'Kocaeli', 'temel gıda'),
('Tukaş', 'Gönül Deniz', '0232 666 0808', 'info@tukas.com.tr', 'İzmir', 'temel gıda'),
('Hellmann''s', 'Onur Tan', '0212 666 0909', 'info@hellmanns.com', 'İstanbul', 'temel gıda'),
('Heinz', 'Nazan Üstün', '0216 666 1010', 'info@heinz.com', 'İstanbul', 'temel gıda'),
('Calve', 'Serap Yılmaz', '0212 666 1111', 'info@calve.com', 'İstanbul', 'temel gıda'),
('Söke Un', 'Ayhan Öz', '0256 777 1212', 'info@sokeun.com', 'Aydın', 'temel gıda'),
('Sinangil Un', 'Gökhan Ar', '0212 777 1313', 'info@sinangil.com.tr', 'İstanbul', 'temel gıda'),
('Irmak Şeker', 'Fatih Gülen', '0224 777 1414', 'info@irmak.com.tr', 'Bursa', 'temel gıda'),
('Türk Şeker', 'Hakan Kol', '0312 777 1515', 'info@turkseker.gov.tr', 'Ankara', 'temel gıda'),
('Bor Şeker', 'Fırat Duran', '0212 777 1616', 'info@borseker.com', 'İstanbul', 'temel gıda');
-- içecek
insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
('Coca Cola', 'Kerem Aydın', '0212 400 1001', 'info@cocacola.com', 'İstanbul', 'içecek'),
('Pepsi', 'Sinem Kar', '0216 400 1002', 'info@pepsi.com', 'İstanbul', 'içecek'),
('Red Bull', 'Cenk Öz', '0212 400 1003', 'info@redbull.com', 'İstanbul', 'içecek'),
('Çamlıca Gazoz', 'Ali Demir', '0212 400 1004', 'info@camlica.com', 'İstanbul', 'içecek'),
('Sprite', 'Gökhan Er', '0212 400 1005', 'info@sprite.com', 'İstanbul', 'içecek'),
('Fanta', 'Tuna Korkmaz', '0212 400 1006', 'info@fanta.com', 'İstanbul', 'içecek'),
('Schweppes', 'Ece Güler', '0212 400 1007', 'info@schweppes.com', 'İstanbul', 'içecek'),
('Uludağ', 'Emre Yavuz', '0224 400 1008', 'info@uludag.com', 'Bursa', 'içecek'),
('Sütaş', 'Hakan Şimşek', '0224 400 1009', 'info@sutas.com', 'Bursa', 'içecek'),
('Altınkılıç', 'Cem Kılıç', '0262 400 1010', 'info@altinkilic.com', 'Kocaeli', 'içecek'),
('Eker', 'Nazan Kır', '0224 400 1011', 'info@eker.com.tr', 'Bursa', 'içecek'),
('Cappy', 'Mehmet Yalçın', '0212 400 1012', 'info@cappy.com', 'İstanbul', 'içecek'),
('Dimes', 'Serap Öz', '0232 400 1013', 'info@dimes.com.tr', 'İzmir', 'içecek'),
('Tamek', 'Volkan Aslan', '0262 400 1014', 'info@tamek.com.tr', 'Kocaeli', 'içecek'),
('İçim', 'Ayhan Uçar', '0212 400 1015', 'info@icim.com.tr', 'İstanbul', 'içecek'),
('Torku', 'Cihat Kar', '0332 400 1016', 'info@torku.com.tr', 'Konya', 'içecek'),
('Doğanay', 'Onur Derin', '0322 400 1017', 'info@doganay.com.tr', 'Adana', 'içecek'),
('Lipton', 'Leyla Tan', '0212 400 1018', 'info@lipton.com', 'İstanbul', 'içecek'),
('Çaykur', 'Murat Ar', '0462 400 1019', 'info@caykur.gov.tr', 'Rize', 'içecek'),
('Fuse Tea', 'Erkan Şen', '0212 400 1020', 'info@fusetea.com', 'İstanbul', 'içecek'),
('Doğadan', 'Cansu Erden', '0312 400 1021', 'info@dogadan.com', 'Ankara', 'içecek'),
('Doğuş Çay', 'Gamze Pek', '0216 400 1022', 'info@doguscay.com', 'İstanbul', 'içecek'),
('Kurukahveci Mehmet Efendi', 'Mehmet Dede', '0212 400 1023', 'info@mehmetefendi.com', 'İstanbul', 'içecek'),
('Kahve Dünyası', 'Selin Aşan', '0212 400 1024', 'info@kahvedunyasi.com', 'İstanbul', 'içecek'),
('Nescafe', 'Serdar Kol', '0212 400 1025', 'info@nescafe.com', 'İstanbul', 'içecek'),
('Tchibo', 'Ahmet Uğur', '0212 400 1026', 'info@tchibo.com', 'İstanbul', 'içecek'),
('Starbucks', 'Beste Kılıç', '0212 400 1027', 'info@starbucks.com', 'İstanbul', 'içecek'),
('SEK', 'Gökçe Yalın', '0216 400 1028', 'info@sek.com.tr', 'İstanbul', 'içecek'),
('Jacobs', 'Cem Atalay', '0212 400 1029', 'info@jacobs.com', 'İstanbul', 'içecek'),
('Obsesso', 'Aslı Sener', '0216 400 1030', 'info@obsesso.com', 'İstanbul', 'içecek'),
('Erikli', 'Ali Kaya', '0224 400 1031', 'info@erikli.com', 'Bursa', 'içecek'),
('Damla Su', 'Tuna Er', '0268 400 1032', 'info@damlasu.com', 'Sakarya', 'içecek'),
('Buzdağı Su', 'Gökhan Dinç', '0372 400 1033', 'info@buzdagi.com', 'Zonguldak', 'içecek'),
('Hayat Su', 'Emine Ar', '0216 400 1034', 'info@hayatsu.com', 'İstanbul', 'içecek'),
('Sırma Su', 'Melisa Soy', '0212 400 1035', 'info@sirma.com.tr', 'İstanbul', 'içecek'),
('Kızılay Maden Suyu', 'Fırat Bey', '0312 400 1036', 'info@kizilay.com.tr', 'Ankara', 'içecek');
-- atiştirmalik
insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
('Tadım', 'Burak Aydın', '0212 410 1001', 'info@tadim.com', 'İstanbul', 'atıştırmalık'),
('Peyman', 'Serkan Yılmaz', '0312 410 1002', 'info@peyman.com', 'Ankara', 'atıştırmalık'),
('Master Nut', 'Ayşe Kar', '0216 410 1003', 'info@masternut.com', 'İstanbul', 'atıştırmalık'),
('Ruffles', 'Cem Er', '0216 410 1004', 'info@ruffles.com', 'İstanbul', 'atıştırmalık'),
('Çerezza', 'Melis Şen', '0216 410 1005', 'info@cerezza.com', 'İstanbul', 'atıştırmalık'),
('Doritos', 'Kaan Polat', '0216 410 1006', 'info@doritos.com', 'İstanbul', 'atıştırmalık'),
('Züber', 'Eda Soy', '0212 410 1007', 'info@zuber.com.tr', 'İstanbul', 'atıştırmalık'),
('Lay''s', 'Tolga Demir', '0216 410 1008', 'info@lays.com', 'İstanbul', 'atıştırmalık'),
('Cheetos', 'Hakan Ar', '0216 410 1009', 'info@cheetos.com', 'İstanbul', 'atıştırmalık'),
('Patos', 'Emre Kılıç', '0216 410 1010', 'info@patos.com', 'İstanbul', 'atıştırmalık'),
('Kahve Dünyası', 'Selin Aksoy', '0212 410 1011', 'info@kahvedunyasi.com', 'İstanbul', 'atıştırmalık'),
('Eti', 'Murat Yıldız', '0222 410 1012', 'info@eti.com.tr', 'Eskişehir', 'atıştırmalık'),
('Ülker', 'Onur Kaya', '0212 410 1013', 'info@ulker.com.tr', 'İstanbul', 'atıştırmalık'),
('Tadelle', 'Serap Deniz', '0262 410 1014', 'info@tadelle.com', 'Kocaeli', 'atıştırmalık'),
('Milka', 'Büşra Er', '0212 410 1015', 'info@milka.com', 'İstanbul', 'atıştırmalık'),
('Nestle', 'Can Yılmaz', '0212 410 1016', 'info@nestle.com', 'İstanbul', 'atıştırmalık'),
('Torku', 'Ahmet Karaca', '0332 410 1017', 'info@torku.com.tr', 'Konya', 'atıştırmalık'),
('Haribo', 'Deniz Uçar', '0212 410 1018', 'info@haribo.com', 'İstanbul', 'atıştırmalık'),
('Olips', 'Zeynep Arslan', '0212 410 1019', 'info@olips.com', 'İstanbul', 'atıştırmalık'),
('Falım', 'Emre Şahin', '0212 410 1020', 'info@falim.com.tr', 'İstanbul', 'atıştırmalık'),
('First', 'Gökhan Öz', '0212 410 1021', 'info@firstgum.com', 'İstanbul', 'atıştırmalık'),
('Vivident', 'Aslı Korkmaz', '0212 410 1022', 'info@vivident.com', 'İstanbul', 'atıştırmalık');
-- dondurma
insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
('Algida', 'Merve Aydın', '0212 420 1001', 'info@algida.com', 'İstanbul', 'dondurma'),
('Magnum', 'Kerem Yılmaz', '0212 420 1002', 'info@magnum.com', 'İstanbul', 'dondurma'),
('Carte d''Or', 'Selin Demir', '0212 420 1003', 'info@cartedor.com', 'İstanbul', 'dondurma');
-- firin pastane
insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
('UNO', 'Ahmet Yılmaz', '0212 430 1001', 'info@uno.com.tr', 'İstanbul', 'fırın – pastane'),
('Dr. Oetker', 'Selin Kaya', '0212 430 1002', 'info@droetker.com.tr', 'İstanbul', 'fırın – pastane'),
('Bahçelievler Taze Ekmek Fırını', 'Mehmet Usta', '0212 430 2001', 'bahcelievler@tazeekmek.com', 'İstanbul – Bahçelievler', 'fırın – pastane'),
('Çankaya Halk Fırını',' Ali Kaya', '0312 430 2002', 'cankaya@halkfirini.com', 'Ankara – Çankaya', 'fırın – pastane'),
('Konak Günlük Ekmek Fırını', 'Hasan Demir', '0232 430 2003', 'konak@gunlukekmek.com', 'İzmir – Konak', 'fırın – pastane');
-- hazir yemek-donuk
insert into supplier(supplier_name, contact_person, phone, email, address, supplier_type)
values
('SuperFresh', 'Merve Aydın', '0212 450 1001', 'info@superfresh.com.tr', 'İstanbul', 'hazır yemek - donuk'),
('Dr. Oetker', 'Selin Kaya', '0212 450 1002', 'info@droetker.com.tr', 'İstanbul', 'hazır yemek - donuk'),
('Lavi', 'Burak Yılmaz', '0216 450 1003', 'info@lavi.com.tr', 'İstanbul', 'hazır yemek - donuk'),
('Mr. No', 'Emre Şahin', '0212 450 1004', 'info@mrno.com.tr', 'İstanbul', 'hazır yemek - donuk'),
('Dardanel', 'Ahmet Demir', '0286 450 1005', 'info@dardanel.com.tr', 'Çanakkale', 'hazır yemek - donuk');
-- deterjan-temizlik
insert into supplier(supplier_name, contact_person, phone, email, address, supplier_type)
values
('Sleepy', 'Ayşe Demir', '0212 470 1001', 'info@sleepy.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Domestos', 'Mehmet Yılmaz', '0212 470 1002', 'info@domestos.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Cif', 'Elif Kaya', '0212 470 1003', 'info@cif.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Camsil', 'Burak Aydın', '0212 470 1004', 'info@camsil.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Porçöz', 'Zeynep Arslan', '0212 470 1005', 'info@porcoz.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Pril', 'Can Özdemir', '0212 470 1006', 'info@pril.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Perwoll', 'Selin Karaca', '0212 470 1007', 'info@perwoll.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Yumoş', 'Hakan Polat', '0212 470 1008', 'info@yumos.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Bingo', 'Murat Çetin', '0212 470 1009', 'info@bingo.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Omo', 'Deniz Şahin', '0212 470 1010', 'info@omo.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Fairy', 'Ahmet Korkmaz', '0212 470 1011', 'info@fairy.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Parex', 'Gizem Yıldız', '0212 470 1012', 'info@parex.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Scotch Brite', 'Serkan Öz', '0212 470 1013', 'info@scotchbrite.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Koroplast', 'Emre Aksoy', '0212 470 1014', 'info@koroplast.com.tr', 'İstanbul', 'deterjan - temizlik'),
('Asperox', 'Büşra Taş', '0212 470 1015', 'info@asperox.com.tr', 'İstanbul', 'deterjan - temizlik');
-- alkol
insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
('efes pazarlama a.ş.', 'mehmet kaya', '0212 555 0101', 'info@efespazarlama.com', 'istanbul', 'alkol'),
('tuborg pazarlama a.ş.', 'ahmet demir', '0212 555 0102', 'info@tuborg.com', 'istanbul', 'alkol'),
('kavaklıdere şarapları', 'ali yılmaz', '0312 555 0201', 'info@kavaklidere.com', 'ankara', 'alkol'),
('doluca şarapçılık', 'serkan arslan', '0212 555 0202', 'info@doluca.com', 'istanbul', 'alkol'),
('diageo türkiye', 'burcu çelik', '0212 555 0301', 'info@diageo.com', 'istanbul', 'alkol'),
('pernod ricard türkiye', 'can öz', '0212 555 0302', 'info@pernodricard.com', 'istanbul', 'alkol');
-- sigara
insert into supplier (supplier_name, contact_person, phone, email, address, supplier_type)
values
('philip morris sabancı', 'emre aksoy', '0216 555 0401', 'info@pmi.com', 'istanbul', 'sigara'),
('jti türkiye', 'hakan şen', '0216 555 0402', 'info@jti.com', 'istanbul', 'sigara'),
('british american tobacco', 'selin koç', '0216 555 0403', 'info@bat.com', 'istanbul', 'sigara');

-- meyve ürün 
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(13,'8693000000001','Elma','hal','kg',44.90,1.00,120,'2025-12-16','2025-12-26',0,1,'KG'),
(13,'8693000000002','Muz','hal','kg',59.90,1.00,80 ,'2025-12-17','2025-12-24',0,1,'KG'),
(13,'8693000000003','Portakal','hal','kg',39.90,1.00,100,'2025-12-15','2025-12-29',0,1,'KG'),
(13,'8693000000004','Mandalina','hal','kg',49.90,1.00,90 ,'2025-12-16','2025-12-27',0,1,'KG'),
(13,'8693000000005','Çilek','hal','kg',69.90,1.00,70 ,'2025-12-18','2025-12-23',0,1,'KG'),
(13,'8693000000006','Kiraz','hal','kg',74.90,1.00,60 ,'2025-12-17','2025-12-25',0,1,'KG'),
(13,'8693000000007','Armut','hal','kg',42.90,1.00,85 ,'2025-12-14','2025-12-28',0,1,'KG'),
(13,'8693000000008','Şeftali','hal','kg',54.90,1.00,75 ,'2025-12-16','2025-12-26',0,1,'KG'),
(13,'8693000000009','Üzüm','hal','kg',64.90,1.00,65 ,'2025-12-17','2025-12-24',0,1,'KG'),
(13,'8693000000010','Kivi','hal','kg',89.90,1.00,50 ,'2025-12-15','2025-12-23',0,1,'KG');
-- sebze ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(14,'8693000000101','Domates','hal','kg',34.90,1.00,140,'2025-12-16','2025-12-24',0,1,'KG'),
(14,'8693000000102','Salatalık','hal','kg',29.90,1.00,120,'2025-12-15','2025-12-25',0,1,'KG'),
(14,'8693000000103','Patates','hal','kg',22.90,1.00,200,'2025-12-10','2026-01-05',0,1,'KG'),
(14,'8693000000104','Kuru Soğan','hal','kg',19.90,1.00,180,'2025-12-09','2026-01-10',0,1,'KG'),
(14,'8693000000105','Biber','hal','kg',44.90,1.00,90 ,'2025-12-16','2025-12-23',0,1,'KG'),
(14,'8693000000106','Patlıcan','hal','kg',39.90,1.00,85 ,'2025-12-17','2025-12-24',0,1,'KG'),
(14,'8693000000107','Havuç','hal','kg',24.90,1.00,110,'2025-12-12','2026-01-03',0,1,'KG'),
(14,'8693000000108','Kabak','hal','kg',54.90,1.00,70 ,'2025-12-16','2025-12-26',0,1,'KG'),
(14,'8693000000109','Marul','hal','adet',29.90,1.00,60 ,'2025-12-18','2025-12-22',0,1,'ADET'),
(14,'8693000000110','Karnabahar','hal','adet',34.90,1.00,55 ,'2025-12-17','2025-12-23',0,1,'ADET');
-- kirmizi et ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(15,'8693000000201','Dana Kıyma','Uzman Kasap','kg',549.90,1.00,25,'2025-12-18','2025-12-22',0,1,'KG'),
(15,'8693000000202','Dana Kuşbaşı','Kuruçeşme Kasap','kg',629.90,1.00,18,'2025-12-17','2025-12-22',0,1,'KG'),
(15,'8693000000203','Dana Antrikot','Ege Et Dağıtım','kg',699.90,1.00,12,'2025-12-16','2025-12-22',0,1,'KG'),
(15,'8693000000204','Dana Bonfile','Polonez','kg',589.90,1.00,15,'2025-12-18','2025-12-23',0,1,'KG'),
(15,'8693000000205','Dana Kontrfile','Namet','kg',519.90,1.00,20,'2025-12-17','2025-12-22',0,1,'KG'),
(15,'8693000000206','Kuzu Pirzola','Torku','kg',469.90,1.00,22,'2025-12-16','2025-12-21',0,1,'KG');
-- beyaz et ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(16,'8693000000301','Tavuk Göğüs Fileto','Banvit','kg',189.90,1.00,40,'2025-12-18','2025-12-23',0,1,'KG'),
(16,'8693000000302','Tavuk But','Beypiliç','kg',169.90,1.00,38,'2025-12-17','2025-12-23',0,1,'KG'),
(16,'8693000000303','Tavuk Kanat','Lezita','kg',199.90,1.00,30,'2025-12-16','2025-12-22',0,1,'KG'),
(16,'8693000000304','Tavuk Baget','Keskinoğlu','kg',179.90,1.00,28,'2025-12-18','2025-12-24',0,1,'KG'),
(16,'8693000000305','Hindi Füme Dilim','Pınar','adet',64.90,1.00,60,'2025-12-15','2025-12-30',0,150,'G'),
(16,'8693000000306','Hindi Kuşbaşı','Torku','kg',209.90,1.00,24,'2025-12-17','2025-12-23',0,1,'KG');
-- balik-deniz ürünleri
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(17,'8693000000401','Hamsi','İstanbul Balık Hali','kg',299.90,1.00,22,'2025-12-18','2025-12-21',0,1,'KG'),
(17,'8693000000402','Palamut','Karadeniz Deniz Ürünleri','kg',349.90,1.00,18,'2025-12-17','2025-12-21',0,1,'KG'),
(17,'8693000000403','Levrek','İstanbul Balık Hali','kg',399.90,1.00,14,'2025-12-16','2025-12-21',0,1,'KG'),
(17,'8693000000404','Çipura','Karadeniz Deniz Ürünleri','kg',429.90,1.00,12,'2025-12-18','2025-12-22',0,1,'KG'),
(17,'8693000000405','Ton Balığı Konserve','Dardanel','adet',64.90,1.00,50,'2025-11-20','2026-11-20',0,160,'G'),
(17,'8693000000406','Somon Füme','Dardanel','adet',79.90,1.00,45,'2025-12-01','2026-06-01',0,100,'G');
-- et şarküteri ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(18,'8693000000501','Dana Sucuk','Namet','adet',119.90,1.00,60,'2025-12-10','2026-01-10',0,300,'G'),
(18,'8693000000502','Dana Salam','Polonez','adet',99.90,1.00,55,'2025-12-12','2026-01-05',0,200,'G'),
(18,'8693000000503','Tavuk Sosis','Pınar','adet',89.90,1.00,50,'2025-12-11','2026-01-08',0,400,'G'),
(18,'8693000000504','Dana Pastırma','Torku','adet',109.90,1.00,48,'2025-12-09','2026-01-03',0,100,'G'),
(18,'8693000000505','Hindi Jambon','Namet','adet',79.90,1.00,65,'2025-12-13','2026-01-02',0,150,'G'),
(18,'8693000000506','Dana Füme Et','Pınar','adet',129.90,1.00,40,'2025-12-08','2026-01-01',0,120,'G');
-- süt ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(19,'8695000000601','Günlük Süt','Sütaş','adet',32.90,1.00,120,'2025-12-01','2025-12-11',0,1,'L'),
(19,'8695000000602','Yarım Yağlı Süt','İçim','adet',34.90,1.00,110,'2025-12-02','2025-12-14',0,1,'L'),
(19,'8695000000603','Laktozsuz Süt','SEK','adet',36.90,1.00,100,'2025-12-03','2025-12-18',0,1,'L'),
(19,'8695000000604','Günlük Süt','Sütaş','adet',19.90,1.00,140,'2025-12-04','2025-12-14',0,500,'ML'),
(19,'8695000000605','Yarım Yağlı Süt','İçim','adet',18.90,1.00,150,'2025-12-05','2025-12-17',0,500,'ML'),
(19,'8695000000606','Laktozsuz Süt','SEK','adet',22.90,1.00,130,'2025-12-06','2025-12-21',0,500,'ML');
-- peynir ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(20,'8695000000701','Ezine Peyniri','Tahsildaroğlu','adet',149.90,1.00,60,'2025-11-10','2025-12-10',0,400,'G'),
(20,'8695000000702','Ezine Peyniri','Tahsildaroğlu','adet',239.90,1.00,40,'2025-11-12','2025-12-12',0,800,'G'),
(20,'8695000000703','Burgu Peynir','Muratbey','adet',129.90,1.00,55,'2025-11-14','2025-12-09',0,250,'G'),
(20,'8695000000704','Burgu Peynir','Muratbey','adet',219.90,1.00,35,'2025-11-15','2025-12-10',0,500,'G'),
(20,'8695000000705','Kaşar Peyniri','Bahçıvan','adet',119.90,1.00,50,'2025-11-16','2025-12-11',0,600,'G'),
(20,'8695000000706','Kaşar Peyniri','Bahçıvan','adet',84.90,1.00,65,'2025-11-18','2025-12-13',0,400,'G');
-- yoğurt ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(21,'8695000000801','Yoğurt','Eker','adet',42.90,1.00,90,'2025-12-01','2025-12-11',0,1,'KG'),
(21,'8695000000802','Yoğurt','Eker','adet',74.90,1.00,55,'2025-12-02','2025-12-12',0,2,'KG'),
(21,'8695000000803','Probiyotikli Yoğurt','Activia','adet',29.90,1.00,100,'2025-12-03','2025-12-15',0,500,'G'),
(21,'8695000000804','Kase Yoğurt','Sütaş','adet',24.90,1.00,110,'2025-12-04','2025-12-12',0,400,'G');
-- tereyaği ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(22,'8695000000901','Tereyağı','Ekici','adet',119.90,1.00,40,'2025-10-01','2025-11-30',0,500,'G'),
(22,'8695000000902','Tereyağı','Ekici','adet',74.90,1.00,55,'2025-10-03','2025-12-02',0,250,'G'),
(22,'8695000000903','Tereyağı','Pınar','adet',109.90,1.00,45,'2025-10-05','2025-12-04',0,250,'G');
-- margarin ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(23,'8695000001001','Margarin','Becel','adet',39.90,1.00,90,'2025-09-10','2026-03-10',0,250,'G'),
(23,'8695000001002','Margarin','Becel','adet',64.90,1.00,70,'2025-09-12','2026-03-12',0,500,'G'),
(23,'8695000001003','Margarin','Tamek','adet',59.90,1.00,60,'2025-09-14','2026-03-14',0,250,'G');
-- yumurta ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(24,'8696000001101','Yumurta','Keskinoğlu','adet',69.90,1.00,90,'2025-12-05','2025-12-26',0,10,'ADET'),
(24,'8696000001102','Yumurta','Keskinoğlu','adet',99.90,1.00,70,'2025-12-06','2025-12-27',0,15,'ADET'),
(24,'8696000001103','Yumurta','Keskinoğlu','adet',179.90,1.00,40,'2025-12-07','2025-12-28',0,30,'ADET'),
(24,'8696000001104','Gezen Tavuk Yumurtası','Mlife Yumurta','adet',84.90,1.00,60,'2025-12-06','2025-12-27',0,10,'ADET'),
(24,'8696000001105','Gezen Tavuk Yumurtası','Mlife Yumurta','adet',149.90,1.00,35,'2025-12-08','2025-12-29',0,20,'ADET');
-- zeytin ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(25,'8695000001201','Siyah Zeytin','Marmarabirlik','adet',109.90,1.00,60,'2025-08-20','2026-02-20',0,500,'G'),
(25,'8695000001202','Siyah Zeytin','Marmarabirlik','adet',179.90,1.00,40,'2025-08-22','2026-02-22',0,1,'KG'),
(25,'8695000001203','Yeşil Zeytin','Lio Zeytin','adet',99.90,1.00,55,'2025-08-24','2026-02-24',0,500,'G');
-- krema ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(26,'8695000001301','Sıvı Krema','İçim','adet',42.90,1.00,75,'2025-12-01','2025-12-21',0,200,'ML'),
(26,'8695000001302','Sıvı Krema','İçim','adet',69.90,1.00,55,'2025-12-02','2025-12-22',0,400,'ML'),
(26,'8695000001303','Yemek Kreması','SEK','adet',39.90,1.00,80,'2025-12-03','2025-12-23',0,200,'ML'),
(26,'8695000001310','Sıvı Krema','Tikveşli','adet',44.90,1.00,60,'2025-12-04','2025-12-24',0,200,'ML');
-- kahvaliliklar ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(27,'8697000002001','Fındık Kreması','Nutella','adet',159.90,1.00,80,'2025-10-01','2026-04-01',0,400,'G'),
(27,'8697000002002','Fındık Kreması','Sarelle','adet',149.90,1.00,75,'2025-10-05','2026-04-05',0,350,'G'),
(27,'8697000002003','Çiçek Balı','Balparmak','adet',189.90,1.00,60,'2025-09-20','2026-09-20',0,850,'G'),
(27,'8697000002004','Fıstık Ezmeli Bar','Züber','adet',29.90,1.00,120,'2025-11-01','2026-05-01',0,35,'G'),
(27,'8697000002005','Çilek Reçeli','Torku','adet',64.90,1.00,90,'2025-08-15','2026-02-15',0,380,'G'),
(27,'8697000002006','Kayısı Reçeli','Pınar','adet',59.90,1.00,85,'2025-08-18','2026-02-18',0,380,'G'),
(27,'8697000002007','Petibör Bisküvi','Eti','adet',39.90,1.00,140,'2025-11-10','2026-05-10',0,400,'G'),
(27,'8697000002008','Petit Beurre','Ülker','adet',37.90,1.00,150,'2025-11-12','2026-05-12',0,400,'G'),
(27,'8697000002009','Mısır Gevreği','Nestle','adet',89.90,1.00,70,'2025-10-25','2026-06-25',0,375,'G'),
(27,'8697000002010','Sürülebilir Peynir','Altınkılıç','adet',74.90,1.00,65,'2025-11-05','2025-12-20',0,200,'G');
-- makarna ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(28,'8698100003001','Spagetti Makarna','Filiz Makarna','adet',29.90,1.00,120,'2025-09-01','2027-09-01',0,500,'G'),
(28,'8698100003003','Penne Rigate','Barilla','adet',39.90,1.00,100,'2025-09-05','2027-09-05',0,500,'G'),
(28,'8698100003004','Penne Rigate','Barilla','adet',74.90,1.00,70 ,'2025-09-05','2027-09-05',0,1,'KG'),
(28,'8698100003005','Burgu Makarna','Ankara Makarna','adet',24.90,1.00,110,'2025-09-10','2027-09-10',0,500,'G'),
(28,'8698100003006','Fiyonk Makarna','Mutlu Makarna','adet',22.90,1.00,130,'2025-09-12','2027-09-12',0,500,'G');
-- bakliyat ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(29,'8698100003101','Baldo Pirinç','Yayla','adet',89.90,1.00,90,'2025-08-01','2026-08-01',0,1,'KG'),
(29,'8698100003102','Baldo Pirinç','Yayla','adet',209.90,1.00,55,'2025-08-01','2026-08-01',0,2.5,'KG'),
(29,'8698100003103','Kırmızı Mercimek','Reis','adet',64.90,1.00,85,'2025-08-05','2026-08-05',0,1,'KG'),
(29,'8698100003104','Kırmızı Mercimek','Reis','adet',34.90,1.00,110,'2025-08-05','2026-08-05',0,500,'G'),
(29,'8698100003105','Nohut','Hasata','adet',59.90,1.00,80,'2025-08-10','2026-08-10',0,1,'KG'),
(29,'8698100003106','Yeşil Mercimek','Duru','adet',69.90,1.00,75,'2025-08-12','2026-08-12',0,1,'KG'),
(29,'8698100003107','Pilavlık Bulgur','Fide','adet',34.90,1.00,100,'2025-08-15','2026-08-15',0,1,'KG'),
(29,'8698100003108','Pilavlık Bulgur','Fide','adet',74.90,1.00,60,'2025-08-15','2026-08-15',0,2.5,'KG'),
(29,'8698100003109','Kuru Fasulye','Efsina','adet',79.90,1.00,70,'2025-08-18','2026-08-18',0,1,'KG');
-- sivi yağ ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(30,'8698100003201','Ayçiçek Yağı','Yudum','adet',44.90,1.00,120,'2025-07-01','2026-07-01',0,1,'L'),
(30,'8698100003202','Ayçiçek Yağı','Yudum','adet',149.90,1.00,60 ,'2025-07-01','2026-07-01',0,5,'L'),
(30,'8698100003203','Zeytinyağı','Komili','adet',139.90,1.00,80,'2025-07-05','2026-07-05',0,1,'L'),
(30,'8698100003204','Zeytinyağı','Komili','adet',229.90,1.00,50,'2025-07-05','2026-07-05',0,2,'L');
-- tuz baharat ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(31,'8698100003301','İyotlu Tuz','Billur Tuz','adet',19.90,1.00,150,'2025-06-01','2028-06-01',0,750,'G'),
(31,'8698100003302','İyotlu Tuz','Billur Tuz','adet',34.90,1.00,100,'2025-06-01','2028-06-01',0,1.5,'KG'),
(31,'8698100003303','Karabiber','Bağdat Baharat','adet',29.90,1.00,120,'2025-06-05','2028-06-05',0,70,'G'),
(31,'8698100003304','Pul Biber','Bağdat Baharat','adet',34.90,1.00,110,'2025-06-05','2028-06-05',0,150,'G');
-- bulyon ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(32,'8698100003401','Et Bulyon','Knorr','adet',14.90,1.00,200,'2025-05-01','2027-05-01',0,120,'G'),
(32,'8698100003402','Tavuk Bulyon','Knorr','adet',14.90,1.00,190,'2025-05-01','2027-05-01',0,120,'G');
-- konserve ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(33,'8698100003501','Domates Salçası','Tat','adet',39.90,1.00,90,'2025-06-15','2027-06-15',0,830,'G'),
(33,'8698100003502','Domates Salçası','Tat','adet',74.90,1.00,55,'2025-06-15','2027-06-15',0,1650,'G'),
(33,'8698100003503','Bezelye Konserve','Tukaş','adet',29.90,1.00,85,'2025-06-18','2027-06-18',0,670,'G'),
(33,'8698100003504','Mısır Konserve','Tukaş','adet',24.90,1.00,95,'2025-06-18','2027-06-18',0,420,'G'),
(33,'8698100003505','Fasulye Pilaki','Tamek','adet',34.90,1.00,70,'2025-06-20','2027-06-20',0,400,'G');
-- sos ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(34,'8698100003601','Mayonez','Hellmann''s','adet',49.90,1.00,70,'2025-05-10','2027-05-10',0,430,'G'),
(34,'8698100003602','Mayonez','Hellmann''s','adet',84.90,1.00,45,'2025-05-10','2027-05-10',0,800,'G'),
(34,'8698100003603','Ketçap','Heinz','adet',44.90,1.00,65,'2025-05-12','2027-05-12',0,460,'G'),
(34,'8698100003604','Ketçap','Heinz','adet',79.90,1.00,40,'2025-05-12','2027-05-12',0,800,'G'),
(34,'8698100003605','Hardal','Calve','adet',39.90,1.00,55,'2025-05-15','2027-05-15',0,250,'G');
-- un ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(35,'8698100003701','Buğday Unu','Söke Un','adet',29.90,1.00,110,'2025-07-01','2026-07-01',0,1,'KG'),
(35,'8698100003702','Buğday Unu','Söke Un','adet',54.90,1.00,80 ,'2025-07-01','2026-07-01',0,2,'KG'),
(35,'8698100003703','Buğday Unu','Sinangil Un','adet',27.90,1.00,120,'2025-07-05','2026-07-05',0,1,'KG'),
(35,'8698100003704','Buğday Unu','Sinangil Un','adet',49.90,1.00,85 ,'2025-07-05','2026-07-05',0,2,'KG');
-- şeker ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(36,'8698100003801','Toz Şeker','Irmak Şeker','adet',44.90,1.00,100,'2025-08-01','2027-08-01',0,1,'KG'),
(36,'8698100003802','Toz Şeker','Irmak Şeker','adet',84.90,1.00,60 ,'2025-08-01','2027-08-01',0,2,'KG'),
(36,'8698100003803','Toz Şeker','Türk Şeker','adet',42.90,1.00,120,'2025-08-05','2027-08-05',0,1,'KG'),
(36,'8698100003804','Toz Şeker','Bor Şeker','adet',41.90,1.00,110,'2025-08-08','2027-08-08',0,1,'KG');
-- gazli içecek ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(37,'8698200004001','Kola','Coca Cola','adet',29.90,1.00,120,'2025-10-01','2026-10-01',0,330,'ML'),
(37,'8698200004002','Kola','Coca Cola','adet',39.90,1.00,100,'2025-10-01','2026-10-01',0,1,'L'),
(37,'8698200004003','Kola','Pepsi','adet',28.90,1.00,110,'2025-10-02','2026-10-02',0,330,'ML'),
(37,'8698200004004','Sprite','Sprite','adet',29.90,1.00,95,'2025-10-03','2026-10-03',0,330,'ML'),
(37,'8698200004005','Portakallı Gazoz','Fanta','adet',29.90,1.00,90,'2025-10-04','2026-10-04',0,330,'ML'),
(37,'8698200004006','Tonik','Schweppes','adet',34.90,1.00,80,'2025-10-05','2026-10-05',0,330,'ML'),
(37,'8698200004007','Gazoz','Çamlıca Gazoz','adet',24.90,1.00,130,'2025-10-06','2026-10-06',0,250,'ML'),
(37,'8698200004010','Enerji İçeceği','Red Bull','adet',39.90,1.00,120,'2025-10-08','2026-10-08',0,250,'ML'),
(37,'8698200004011','Enerji İçeceği','Red Bull','adet',49.90,1.00,90,'2025-10-08','2026-10-08',0,355,'ML');
-- gazsiz içecek ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(38,'8698200004101','Meyve Suyu','Cappy','adet',34.90,1.00,90,'2025-09-01','2026-09-01',0,1,'L'),
(38,'8698200004102','Şeftali Suyu','Dimes','adet',32.90,1.00,85,'2025-09-02','2026-09-02',0,1,'L'),
(38,'8698200004103','Şalgam Suyu','Doğanay','adet',29.90,1.00,100,'2025-09-03','2026-09-03',0,1,'L'),
(38,'8698200004104','Soğuk Çay','Fuse Tea','adet',27.90,1.00,95,'2025-09-04','2026-09-04',0,500,'ML'),
(38,'8698200004105','Soğuk Çay','Fuse Tea','adet',19.90,1.00,110,'2025-09-04','2026-09-04',0,330,'ML'),
(38,'8698200004106','Vişne Suyu','Tamek','adet',36.90,1.00,80,'2025-09-05','2026-09-05',0,1,'L'),
(38,'8698300005001','Ayran','Sütaş','adet',14.90,1.00,120,'2025-11-01','2025-11-11',0,250,'ML'),
(38,'8698300005002','Ayran','Sütaş','adet',24.90,1.00,90 ,'2025-11-01','2025-11-11',0,1,'L'),
(38,'8698300005003','Kefir','Altınkılıç','adet',29.90,1.00,80 ,'2025-11-02','2025-11-17',0,250,'ML'),
(38,'8698300005004','Ayran','Eker','adet',13.90,1.00,130,'2025-11-03','2025-11-13',0,250,'ML'),
(38,'8698300005005','Ayran','Eker','adet',22.90,1.00,95 ,'2025-11-03','2025-11-13',0,1,'L'),
(38,'8698300005006','Ayran','İçim','adet',14.90,1.00,110,'2025-11-04','2025-11-14',0,250,'ML'),
(38,'8698300005007','Kefir','İçim','adet',32.90,1.00,70 ,'2025-11-04','2025-11-19',0,1,'L'),
(38,'8698300005008','Ayran','Torku','adet',12.90,1.00,140,'2025-11-05','2025-11-15',0,250,'ML'),
(38,'8698300005009','Ayran','SEK','adet',13.90,1.00,125,'2025-11-06','2025-11-16',0,250,'ML');
-- çay ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(39,'8698200004201','Siyah Çay','Çaykur','adet',89.90,1.00,70,'2025-08-01','2027-08-01',0,1,'KG'),
(39,'8698200004202','Siyah Çay','Çaykur','adet',49.90,1.00,90,'2025-08-01','2027-08-01',0,500,'G'),
(39,'8698200004203','Siyah Çay','Lipton','adet',79.90,1.00,65,'2025-08-02','2027-08-02',0,1,'KG'),
(39,'8698200004204','Bitki Çayı','Doğadan','adet',44.90,1.00,60,'2025-08-03','2027-08-03',0,20,'ADET'),
(39,'8698200004205','Siyah Çay','Doğuş Çay','adet',69.90,1.00,75,'2025-08-04','2027-08-04',0,1,'KG');
-- kahve ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(40,'8698200004301','Türk Kahvesi','Kurukahveci Mehmet Efendi','adet',64.90,1.00,60,'2025-07-01','2027-07-01',0,100,'G'),
(40,'8698200004302','Türk Kahvesi','Kahve Dünyası','adet',59.90,1.00,55,'2025-07-02','2027-07-02',0,100,'G'),
(40,'8698200004303','Granül Kahve','Nescafe','adet',74.90,1.00,70,'2025-07-03','2027-07-03',0,200,'G'),
(40,'8698200004304','Filtre Kahve','Tchibo','adet',99.90,1.00,40,'2025-07-04','2027-07-04',0,250,'G'),
(40,'8698200004305','Çekirdek Kahve','Starbucks','adet',129.90,1.00,35,'2025-07-05','2027-07-05',0,250,'G'),
(40,'8698200004306','Filtre Kahve','Jacobs','adet',89.90,1.00,50,'2025-07-06','2027-07-06',0,250,'G'),
(40,'8698200004307','Espresso Kahve','Obsesso','adet',94.90,1.00,45,'2025-07-07','2027-07-07',0,250,'G');
-- su ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(41,'8698200004401','İçme Suyu','Erikli','adet',7.90,1.00,300,'2025-11-01','2026-11-01',0,500,'ML'),
(41,'8698200004402','İçme Suyu','Damla Su','adet',9.90,1.00,280,'2025-11-02','2026-11-02',0,1.5,'L'),
(41,'8698200004403','İçme Suyu','Buzdağı Su','adet',8.90,1.00,260,'2025-11-03','2026-11-03',0,500,'ML'),
(41,'8698200004404','İçme Suyu','Hayat Su','adet',12.90,1.00,200,'2025-11-04','2026-11-04',0,5,'L'),
(41,'8698200004405','İçme Suyu','Sırma Su','adet',6.90,1.00,320,'2025-11-05','2026-11-05',0,500,'ML');
-- maden suyu ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity,
 production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(42,'8698200004501','Maden Suyu','Kızılay Maden Suyu','adet',8.90,1.00,200,'2025-10-10','2026-10-10',0,200,'ML'),
(42,'8698200004502','Maden Suyu','Uludağ','adet',7.90,1.00,220,'2025-10-11','2026-10-11',0,200,'ML');
-- kuru meyve ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(43,'8698400006001','Kuru Kayısı','Tadım','adet',79.90,1.00,60,'2025-10-01','2026-10-01',0,200,'G'),
(43,'8698400006002','Kuru Üzüm','Tadım','adet',69.90,1.00,70,'2025-10-01','2026-10-01',0,200,'G');
-- kuruyemiş ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(44,'8698400006101','Kavrulmuş Fındık','Peyman','adet',89.90,1.00,55,'2025-10-02','2026-10-02',0,180,'G'),
(44,'8698400006102','Kavrulmuş Badem','Peyman','adet',109.90,1.00,45,'2025-10-02','2026-10-02',0,180,'G'),
(44,'8698400006103','Karışık Kuruyemiş','Master Nut','adet',99.90,1.00,50,'2025-10-03','2026-10-03',0,200,'G');
-- cips ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(45,'8698400006201','Patates Cipsi Klasik','Ruffles','adet',34.90,1.00,90,'2025-10-04','2026-04-04',0,107,'G'),
(45,'8698400006202','Patates Cipsi Klasik','Ruffles','adet',19.90,1.00,120,'2025-10-04','2026-04-04',0,50,'G'),
(45,'8698400006203','Mısır Çerezi','Çerezza','adet',24.90,1.00,110,'2025-10-05','2026-04-05',0,75,'G'),
(45,'8698400006204','Nacho Cips','Doritos','adet',32.90,1.00,95,'2025-10-05','2026-04-05',0,96,'G'),
(45,'8698400006205','Patates Cipsi Klasik','Lay''s','adet',29.90,1.00,140,'2025-10-06','2026-04-06',0,96,'G'),
(45,'8698400006206','Patates Cipsi Klasik','Lay''s','adet',17.90,1.00,160,'2025-10-06','2026-04-06',0,50,'G'),
(45,'8698400006207','Peynirli Mısır Çerezi','Cheetos','adet',21.90,1.00,130,'2025-10-07','2026-04-07',0,50,'G'),
(45,'8698400006208','Baharatlı Cips','Patos','adet',18.90,1.00,150,'2025-10-07','2026-04-07',0,50,'G');
-- çikolata ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(46,'8698400006301','Sütlü Çikolata','Milka','adet',39.90,1.00,80,'2025-09-01','2026-09-01',0,100,'G'),
(46,'8698400006302','Sütlü Çikolata','Milka','adet',22.90,1.00,100,'2025-09-01','2026-09-01',0,45,'G'),
(46,'8698400006303','Bitter Çikolata','Nestle','adet',34.90,1.00,85,'2025-09-02','2026-09-02',0,80,'G'),
(46,'8698400006304','Sütlü Çikolata','Ülker','adet',19.90,1.00,120,'2025-09-03','2026-09-03',0,65,'G'),
(46,'8698400006305','Çikolata','Eti','adet',21.90,1.00,110,'2025-09-03','2026-09-03',0,60,'G'),
(46,'8698400006306','Fındıklı Çikolata','Tadelle','adet',24.90,1.00,105,'2025-09-04','2026-09-04',0,52,'G'),
(46,'8698400006307','Sütlü Çikolata','Torku','adet',23.90,1.00,100,'2025-09-05','2026-09-05',0,80,'G');
-- gofret ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(47,'8698400006401','Gofret','Eti','adet',12.90,1.00,160,'2025-09-10','2026-09-10',0,40,'G'),
(47,'8698400006402','Gofret','Ülker','adet',11.90,1.00,170,'2025-09-10','2026-09-10',0,40,'G');
-- bar- kaplamalilar ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(48,'8698400006501','Protein Bar','Züber','adet',29.90,1.00,90,'2025-10-01','2026-10-01',0,45,'G'),
(48,'8698400006502','Meyve Bar','Züber','adet',24.90,1.00,95,'2025-10-01','2026-10-01',0,40,'G'),
(48,'8698400006503','Çikolata Bar','Kahve Dünyası','adet',27.90,1.00,80,'2025-10-02','2026-10-02',0,50,'G');
-- bisküvi ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(49,'8698400006601','Bisküvi','Eti','adet',22.90,1.00,110,'2025-09-15','2026-09-15',0,200,'G'),
(49,'8698400006602','Bisküvi','Ülker','adet',21.90,1.00,120,'2025-09-15','2026-09-15',0,200,'G');
-- kek ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(50,'8698400006701','Kek','Eti','adet',14.90,1.00,140,'2025-09-20','2026-03-20',0,45,'G'),
(50,'8698400006702','Kek','Ülker','adet',13.90,1.00,150,'2025-09-20','2026-03-20',0,45,'G');
-- kraker ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(51,'8698400006801','Tuzlu Kraker','Eti','adet',19.90,1.00,130,'2025-09-25','2026-09-25',0,150,'G'),
(51,'8698400006802','Tuzlu Kraker','Ülker','adet',18.90,1.00,140,'2025-09-25','2026-09-25',0,150,'G');
-- misir-pirinç patlaği ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(52,'8698400006901','Mısır Patlağı','Master Nut','adet',24.90,1.00,90,'2025-10-03','2026-10-03',0,60,'G'),
(52,'8698400006902','Pirinç Patlağı','Master Nut','adet',29.90,1.00,80,'2025-10-03','2026-10-03',0,60,'G');
-- şekerleme ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(53,'8698400007001','Jelibon','Haribo','adet',34.90,1.00,100,'2025-09-01','2026-09-01',0,80,'G'),
(53,'8698400007002','Jelibon','Haribo','adet',49.90,1.00,80,'2025-09-01','2026-09-01',0,160,'G'),
(53,'8698400007003','Şeker','Olips','adet',14.90,1.00,140,'2025-09-02','2026-09-02',0,30,'G');
-- sakiz ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(54,'8698400007101','Sakız','Falım','adet',12.90,1.00,180,'2025-09-05','2026-09-05',0,27,'G'),
(54,'8698400007102','Sakız','First','adet',13.90,1.00,170,'2025-09-05','2026-09-05',0,27,'G'),
(54,'8698400007103','Sakız','Vivident','adet',14.90,1.00,160,'2025-09-05','2026-09-05',0,27,'G');
-- dondurma ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(7,'8699000007001','Cornetto Classico','Algida','adet',39.90,1.00,80,'2025-03-01','2026-03-01',0,110,'ML'),
(7,'8699000007002','Cornetto Disc','Algida','adet',42.90,1.00,70,'2025-03-01','2026-03-01',0,120,'ML'),
(7,'8699000007003','Max Twister','Algida','adet',34.90,1.00,90,'2025-03-02','2026-03-02',0,90,'ML'),
(7,'8699000007010','Magnum Classic','Magnum','adet',49.90,1.00,60,'2025-03-03','2026-03-03',0,100,'ML'),
(7,'8699000007011','Magnum Badem','Magnum','adet',54.90,1.00,55,'2025-03-03','2026-03-03',0,100,'ML'),
(7,'8699000007012','Magnum Mini','Magnum','adet',89.90,1.00,40,'2025-03-03','2026-03-03',0,6,'ADET'),
(7,'8699000007020','Carte d''Or Vanilya','Carte d''Or','adet',139.90,1.00,35,'2025-02-15','2026-02-15',0,850,'ML'),
(7,'8699000007021','Carte d''Or Çikolata','Carte d''Or','adet',139.90,1.00,35,'2025-02-15','2026-02-15',0,850,'ML'),
(7,'8699000007022','Carte d''Or Karamel','Carte d''Or','adet',149.90,1.00,30,'2025-02-16','2026-02-16',0,1000,'ML');
-- ekmek ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(55,'8699100008001','Sandviç Ekmeği','UNO','adet',29.90,1.00,80,'2025-12-20','2025-12-25',0,400,'G'),
(55,'8699100008002','Tam Buğday Ekmeği','UNO','adet',34.90,1.00,70,'2025-12-20','2025-12-25',0,500,'G'),
(55,'8699100008003','Hamburger Ekmeği','UNO','adet',39.90,1.00,60,'2025-12-20','2025-12-26',0,6,'ADET'),
(55,'8699100008010','Günlük Beyaz Ekmek','Bahçelievler Taze Ekmek Fırını','adet',10.00,1.00,200,'2025-12-22','2025-12-23',0,200,'G'),
(55,'8699100008011','Kepekli Ekmek','Bahçelievler Taze Ekmek Fırını','adet',12.00,1.00,180,'2025-12-22','2025-12-23',0,200,'G'),
(55,'8699100008012','Çavdar Ekmeği','Çankaya Halk Fırını','adet',14.00,1.00,160,'2025-12-22','2025-12-24',0,250,'G'),
(55,'8699100008013','Taş Fırın Ekmeği','Konak Günlük Ekmek Fırını','adet',13.00,1.00,170,'2025-12-22','2025-12-24',0,220,'G');
-- hamur-pasta malzemeleri
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(57,'8699100008101','Kakao','Dr. Oetker','adet',29.90,1.00,90,'2025-11-01','2026-11-01',0,25,'G'),
(57,'8699100008102','Kakao','Dr. Oetker','adet',54.90,1.00,60,'2025-11-01','2026-11-01',0,50,'G'),
(57,'8699100008103','Vanilin','Dr. Oetker','adet',9.90,1.00,140,'2025-11-05','2026-11-05',0,5,'G'),
(57,'8699100008104','Kabartma Tozu','Dr. Oetker','adet',8.90,1.00,160,'2025-11-05','2026-11-05',0,10,'G'),
(57,'8699100008105','Şekerli Vanilin','Dr. Oetker','adet',10.90,1.00,130,'2025-11-06','2026-11-06',0,5,'G'),
(57,'8699100008110','Kuru Maya','Dr. Oetker','adet',14.90,1.00,120,'2025-11-10','2026-11-10',0,10,'G'),
(57,'8699100008111','Instant Maya','Dr. Oetker','adet',24.90,1.00,100,'2025-11-10','2026-11-10',0,25,'G'),
(57,'8699100008112','Pudra Şekeri','Dr. Oetker','adet',19.90,1.00,110,'2025-11-12','2026-11-12',0,150,'G');
-- paketli sandviç
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(62,'8699200006201','Ton Balıklı Sandviç','SuperFresh','adet',49.90,1.00,60,'2025-12-15','2025-12-22',0,180,'G'),
(62,'8699200006202','Tavuklu Sandviç','SuperFresh','adet',46.90,1.00,55,'2025-12-15','2025-12-22',0,170,'G'),
(62,'8699200006210','Hindi Füme Sandviç','Lavi','adet',44.90,1.00,70,'2025-12-16','2025-12-23',0,165,'G'),
(62,'8699200006211','Kaşarlı Sandviç','Lavi','adet',42.90,1.00,65,'2025-12-16','2025-12-23',0,160,'G'),
(62,'8699200006220','Etli Sandviç','Mr. No','adet',52.90,1.00,50,'2025-12-17','2025-12-24',0,190,'G'),
(62,'8699200006230','Ton Balıklı Sandviç','Dardanel','adet',54.90,1.00,45,'2025-12-17','2025-12-25',0,185,'G');
-- dondurulmuş gida
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(64,'8699200006401','Dondurulmuş Bezelye','SuperFresh','adet',39.90,1.00,90,'2025-10-01','2026-10-01',0,450,'G'),
(64,'8699200006402','Dondurulmuş Karışık Sebze','SuperFresh','adet',44.90,1.00,85,'2025-10-01','2026-10-01',0,450,'G'),
(64,'8699200006410','Dondurulmuş Pizza Margarita','Dr. Oetker','adet',79.90,1.00,60,'2025-09-20','2026-09-20',0,400,'G'),
(64,'8699200006411','Dondurulmuş Pizza Karışık','Dr. Oetker','adet',84.90,1.00,55,'2025-09-20','2026-09-20',0,420,'G'),
(64,'8699200006420','Dondurulmuş Balık Nugget','Dardanel','adet',69.90,1.00,50,'2025-09-25','2026-09-25',0,300,'G'),
(64,'8699200006421','Dondurulmuş Kalamar','Dardanel','adet',99.90,1.00,40,'2025-09-25','2026-09-25',0,250,'G');
-- genel temizik ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(65,'8699300006501','Çamaşır Suyu','Domestos','adet',49.90,20.00,90,'2025-11-01','2027-11-01',0,750,'ML'),
(65,'8699300006502','Çamaşır Suyu','Domestos','adet',79.90,20.00,70,'2025-11-01','2027-11-01',0,1500,'ML'),
(65,'8699300006510','Krem Temizleyici','Cif','adet',39.90,20.00,110,'2025-11-05','2027-11-05',0,500,'ML'),
(65,'8699300006511','Yüzey Temizleyici Sprey','Cif','adet',44.90,20.00,95,'2025-11-05','2027-11-05',0,750,'ML'),
(65,'8699300006520','Kireç Çözücü','Porçöz','adet',54.90,20.00,80,'2025-10-20','2027-10-20',0,750,'ML'),
(65,'8699300006521','Yağ Çözücü','Porçöz','adet',59.90,20.00,75,'2025-10-20','2027-10-20',0,750,'ML'),
(65,'8699300006530','Sarı Güç (Çok Amaçlı Temizleyici)','Asperox','adet',69.90,20.00,85,'2025-10-15','2027-10-15',0,1,'L'),
(65,'8699300006540','Cam Temizleyici','Camsil','adet',44.90,20.00,90,'2025-10-20','2027-10-20',0,750,'ML'),
(65,'8699300006541','Cam Temizleyici','Camsil','adet',69.90,20.00,70,'2025-10-20','2027-10-20',0,1500,'ML');
-- çamaşir yikama ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(66,'8699300006601','Toz Deterjan','Omo','adet',139.90,20.00,60,'2025-09-01','2027-09-01',0,3,'KG'),
(66,'8699300006602','Sıvı Deterjan','Omo','adet',159.90,20.00,55,'2025-09-01','2027-09-01',0,2,'L'),
(66,'8699300006610','Sıvı Deterjan Siyahlar','Perwoll','adet',149.90,20.00,50,'2025-09-10','2027-09-10',0,2,'L'),
(66,'8699300006611','Sıvı Deterjan Renkliler','Perwoll','adet',149.90,20.00,45,'2025-09-10','2027-09-10',0,2,'L'),
(66,'8699300006620','Toz Deterjan','Bingo','adet',99.90,20.00,70,'2025-09-15','2027-09-15',0,3,'KG'),
(66,'8699300006621','Yumuşatıcı','Bingo','adet',79.90,20.00,80,'2025-09-15','2027-09-15',0,1440,'ML'),
(66,'8699300006630','Yumuşatıcı','Yumoş','adet',89.90,20.00,75,'2025-09-18','2027-09-18',0,1440,'ML'),
(66,'8699300006631','Yumuşatıcı','Yumoş','adet',54.90,20.00,90,'2025-09-18','2027-09-18',0,720,'ML');
-- bulaşik yikama ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(67,'8699300006701','Bulaşık Deterjanı','Fairy','adet',74.90,20.00,85,'2025-10-01','2027-10-01',0,650,'ML'),
(67,'8699300006702','Bulaşık Deterjanı','Fairy','adet',109.90,20.00,60,'2025-10-01','2027-10-01',0,1350,'ML'),
(67,'8699300006710','Bulaşık Deterjanı','Pril','adet',69.90,20.00,90,'2025-10-05','2027-10-05',0,675,'ML'),
(67,'8699300006711','Bulaşık Makinesi Tableti','Pril','adet',149.90,20.00,50,'2025-10-05','2027-10-05',0,30,'ADET');
-- temizlik malzemeleri ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(68,'8699300006801','Mikrofiber Bez','Parex','adet',39.90,20.00,120,'2025-08-01','2028-08-01',0,3,'ADET'),
(68,'8699300006802','Bulaşık Süngeri','Parex','adet',24.90,20.00,140,'2025-08-01','2028-08-01',0,5,'ADET'),
(68,'8699300006810','Bulaşık Süngeri','Scotch Brite','adet',34.90,20.00,110,'2025-08-10','2028-08-10',0,3,'ADET'),
(68,'8699300006811','Ovma Teli','Scotch Brite','adet',29.90,20.00,130,'2025-08-10','2028-08-10',0,2,'ADET'),
(68,'8699300006820','Islak Mendil','Sleepy','adet',39.90,20.00,110,'2025-08-15','2027-08-15',0,90,'ADET'),
(68,'8699300006821','Yüzey Temizlik Havlusu','Sleepy','adet',49.90,20.00,95,'2025-08-15','2027-08-15',0,100,'ADET');
-- çöp poşeti ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate,
 stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(69,'8699300006901','Büzgülü Çöp Poşeti Orta Boy','Koroplast','adet',49.90,20.00,100,'2025-07-01','2029-07-01',0,15,'ADET'),
(69,'8699300006902','Büzgülü Çöp Poşeti Büyük Boy','Koroplast','adet',59.90,20.00,90,'2025-07-01','2029-07-01',0,10,'ADET'),
(69,'8699300006903','Battal Boy Çöp Poşeti','Koroplast','adet',69.90,20.00,80,'2025-07-01','2029-07-01',0,10,'ADET');

-- bira ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(85, '8690000000011', 'Efes Pilsen', 'Efes', 'adet', 55.00, 20, 200, NULL, NULL, 18, 50, 'cl'),
(85, '8690000010011', 'Efes Pilsen', 'Efes', 'adet', 42.00, 20, 300, NULL, NULL, 18, 33, 'cl'),
(85, '8690000000012', 'Tuborg Gold', 'Tuborg', 'adet', 56.00, 20, 180, NULL, NULL, 18, 50, 'cl');
-- şarap ürün 
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(86, '8690000000021', 'Angora Kırmızı Şarap', 'Kavaklıdere', 'adet', 250.00, 20,40, NULL, NULL, 18, 75, 'cl'),
(86, '8690000000022', 'Villa Doluca Beyaz Şarap', 'Doluca', 'adet', 230.00, 20,35, NULL, NULL, 18, 75, 'cl');
-- viski ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(87, '8690000000031', 'Jack Daniels', 'Jack Daniels', 'adet', 950.00, 20, 15, NULL, NULL, 18, 70, 'cl'),
(87, '8690000030011', 'Jack Daniels', 'Jack Daniels', 'adet', 520.00, 20, 20, NULL, NULL, 18, 35, 'cl'),
(87, '8690000000032', 'Chivas Regal 12 Yıl', 'Chivas Regal', 'adet', 1100.00, 20, 10, NULL, NULL, 18, 70, 'cl');
-- votka ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(88, '8690000040011', 'Absolut Vodka', 'Absolut', 'adet', 520.00, 20, 22, NULL, NULL, 18, 50, 'cl'),
(88, '8690000040012', 'Absolut Vodka', 'Absolut', 'adet', 720.00, 20, 20, NULL, NULL, 18, 70, 'cl'),
(88, '8690000040013', 'Absolut Vodka', 'Absolut', 'adet', 980.00, 20, 10, NULL, NULL, 18, 100, 'cl'),
(88, '8690000000042', 'Smirnoff Red', 'Smirnoff', 'adet', 680.00, 20, 18, NULL, NULL, 18, 70, 'cl');
-- sigara ürün
INSERT INTO product
(category_id, barcode, product_name, brand, unit, unit_price, tax_rate, stock_quantity, production_date, expiry_date, min_age, package_size, package_unit)
VALUES
(84, '8691000001011', 'Marlboro Red', 'Philip Morris', 'adet', 60.00, 20, 500, NULL, NULL, 18, 20, 'adet'),
(84, '8691000001012', 'Marlboro Touch Blue', 'Philip Morris', 'adet', 61.00, 20, 420, NULL, NULL, 18, 20, 'adet'),
(84, '8691000001021', 'Parliament Night Blue', 'Philip Morris', 'adet', 62.00, 20, 380, NULL, NULL, 18, 20, 'adet'),
(84, '8691000001022', 'Parliament Slims', 'Philip Morris', 'adet', 63.00, 20, 300, NULL, NULL, 18, 20, 'adet'),
(84, '8691000001031', 'Winston Slender', 'JTI', 'adet', 57.00, 20, 450, NULL, NULL, 18, 20, 'adet'),
(84, '8691000001032', 'Winston Dark Blue', 'JTI', 'adet', 58.00, 20, 400, NULL, NULL, 18, 20, 'adet'),
(84, '8691000001041', 'Camel Yellow', 'JTI', 'adet', 58.00, 20, 380, NULL, NULL, 18, 20, 'adet');

  
-- müşteriler
INSERT INTO customer
(first_name, last_name, gender, birth_date, email, phone, city, district, address, registration_date)
VALUES
('Hande','Arslan','Female','1966-02-14','istanbul001@mail.com','05110000001','İstanbul','Kartal','Papatya Sk. No:63 D:8','2023-10-13'),
('Eren','Koç','Male','1995-05-11','istanbul002@mail.com','05120000002','İstanbul','Kartal','Ortaköy Cd. No:23 D:19','2025-05-14'),
('Elif','Kaya','Female','1969-03-16','istanbul003@mail.com','05130000003','İstanbul','Beşiktaş','Menekşe Sk. No:130 D:20','2023-02-24'),
('Uğur','Karaca','Male','1997-02-13','istanbul004@mail.com','05140000004','İstanbul','Fatih','Ortaköy Cd. No:108 D:8','2025-07-08'),
('Aslı','Çetin','Female','2001-04-23','istanbul005@mail.com','05150000005','İstanbul','Kadıköy','Fatih Sk. No:179 D:14','2024-11-27'),
('Serkan','Yıldız','Male','1974-08-29','istanbul006@mail.com','05160000006','İstanbul','Üsküdar','Gazi Cd. No:24 D:13','2023-07-18'),
('Tuğçe','Yalçın','Female','1992-01-31','istanbul007@mail.com','05170000007','İstanbul','Esenyurt','Cumhuriyet Cd. No:187 D:15','2023-09-13'),
('Cem','Kaplan','Male','1968-07-15','istanbul008@mail.com','05180000008','İstanbul','Pendik','Şehitler Cd. No:161 D:20','2025-01-10'),
('Aslı','Karaca','Female','1996-08-09','istanbul009@mail.com','05190000009','İstanbul','Bakırköy','Cumhuriyet Cd. No:170 D:8','2024-08-15'),
('Ali','Güler','Male','2003-11-14','istanbul010@mail.com','05200000010','İstanbul','Bakırköy','Halaskargazi Cd. No:72 D:15','2025-01-17'),
('Büşra','Özdemir','Female','1980-12-08','istanbul011@mail.com','05210000011','İstanbul','Beşiktaş','Papatya Sk. No:180 D:3','2023-12-17'),
('Uğur','Taş','Male','1972-05-01','istanbul012@mail.com','05220000012','İstanbul','Maltepe','Halaskargazi Cd. No:70 D:18','2024-03-25'),
('Selin','Kılıç','Female','2002-10-23','istanbul013@mail.com','05230000013','İstanbul','Kadıköy','Menekşe Sk. No:9 D:11','2025-04-01'),
('Serkan','Çelik','Male','1974-06-19','istanbul014@mail.com','05240000014','İstanbul','Sarıyer','Sahil Yolu No:55 D:16','2025-03-21'),
('Nehir','Güneş','Female','1971-05-30','istanbul015@mail.com','05250000015','İstanbul','Esenyurt','Barbaros Blv. No:64 D:18','2024-06-22'),
('Eren','Karataş','Male','1984-03-21','istanbul016@mail.com','05260000016','İstanbul','Sarıyer','Halaskargazi Cd. No:93 D:8','2023-10-11'),
('Hülya','Bulut','Female','1969-01-29','istanbul017@mail.com','05270000017','İstanbul','Kadıköy','Gazi Cd. No:40 D:6','2025-05-14'),
('Tolga','Çelik','Male','1982-04-06','istanbul018@mail.com','05280000018','İstanbul','Ataşehir','Abide-i Hürriyet Cd. No:120 D:17','2024-05-29'),
('Gül','Yılmaz','Female','1995-07-08','istanbul019@mail.com','05290000019','İstanbul','Kartal','Gazi Cd. No:175 D:18','2024-06-30'),
('Barış','Eren','Male','1970-01-02','istanbul020@mail.com','05300000020','İstanbul','Esenyurt','Bahariye Cd. No:41 D:15','2023-01-07'),
('Nisa','Ünal','Female','1987-06-16','istanbul021@mail.com','05310000021','İstanbul','Şişli','Teşvikiye Cd. No:28 D:10','2025-11-05'),
('Tolga','Karaca','Male','1971-11-10','istanbul022@mail.com','05320000022','İstanbul','Üsküdar','Fatih Sk. No:139 D:17','2023-01-02'),
('Yasemin','Kılıç','Female','1986-12-02','istanbul023@mail.com','05330000023','İstanbul','Kadıköy','Gazi Cd. No:93 D:10','2024-05-05'),
('Ahmet','Taş','Male','2004-05-21','istanbul024@mail.com','05340000024','İstanbul','Sarıyer','İnönü Cd. No:22 D:16','2023-05-22'),
('Deniz','Sezer','Female','1999-05-10','istanbul025@mail.com','05350000025','İstanbul','Şişli','Barbaros Blv. No:169 D:16','2023-12-05'),
('Serkan','Erdoğan','Male','2004-02-19','istanbul026@mail.com','05360000026','İstanbul','Sarıyer','Bahariye Cd. No:55 D:18','2024-02-16'),
('Sıla','Aksoy','Female','1982-11-25','istanbul027@mail.com','05370000027','İstanbul','Fatih','Mimar Sinan Cd. No:113 D:17','2025-07-13'),
('Mustafa','Taş','Male','1975-01-30','istanbul028@mail.com','05380000028','İstanbul','Bakırköy','Sahil Yolu No:6 D:19','2024-04-16'),
('Aslı','Güler','Female','1965-04-28','istanbul029@mail.com','05390000029','İstanbul','Bakırköy','Cumhuriyet Cd. No:59 D:3','2023-03-06'),
('Kubilay','Eren','Male','1968-03-06','istanbul030@mail.com','05400000030','İstanbul','Pendik','Menekşe Sk. No:72 D:16','2024-03-14'),
('Gül','Öztürk','Female','1997-06-13','istanbul031@mail.com','05410000031','İstanbul','Sarıyer','Doğan Araslı Blv. No:122 D:8','2025-08-26'),
('Berk','Yıldırım','Male','1973-07-17','istanbul032@mail.com','05420000032','İstanbul','Bakırköy','Gazi Cd. No:169 D:14','2024-12-26'),
('Ceren','Yıldırım','Female','1985-12-13','istanbul033@mail.com','05430000033','İstanbul','Kartal','Cumhuriyet Cd. No:173 D:4','2023-05-05'),
('Yusuf','Eren','Male','2000-11-29','istanbul034@mail.com','05440000034','İstanbul','Bakırköy','Menekşe Sk. No:50 D:7','2025-07-07'),
('Seda','Sarı','Female','1973-03-26','istanbul035@mail.com','05450000035','İstanbul','Esenyurt','Moda Cd. No:64 D:3','2025-06-26'),
('Berk','Dinç','Male','1969-05-24','istanbul036@mail.com','05460000036','İstanbul','Kadıköy','Ortaköy Cd. No:4 D:3','2024-04-29'),
('Büşra','Yıldırım','Female','1986-10-14','istanbul037@mail.com','05470000037','İstanbul','Maltepe','Lale Sk. No:103 D:2','2023-12-04'),
('Yusuf','Yılmaz','Male','1982-07-07','istanbul038@mail.com','05480000038','İstanbul','Esenyurt','Moda Cd. No:74 D:14','2025-09-23'),
('Seda','Karaca','Female','1978-04-24','istanbul039@mail.com','05490000039','İstanbul','Beşiktaş','Cumhuriyet Cd. No:149 D:18','2023-05-05'),
('Eren','Kılıç','Male','1967-07-26','istanbul040@mail.com','05500000040','İstanbul','Kadıköy','Doğan Araslı Blv. No:123 D:17','2025-12-23'),
('Büşra','Şahin','Female','1987-10-13','istanbul041@mail.com','05510000041','İstanbul','Bakırköy','Fatih Sk. No:18 D:20','2023-05-20'),
('İsmail','Taş','Male','1983-02-11','istanbul042@mail.com','05520000042','İstanbul','Bakırköy','Doğan Araslı Blv. No:64 D:19','2023-03-23'),
('Yasemin','Aydın','Female','1983-10-22','istanbul043@mail.com','05530000043','İstanbul','Fatih','Doğan Araslı Blv. No:145 D:17','2024-10-09'),
('Cem','Ünal','Male','1974-03-01','istanbul044@mail.com','05540000044','İstanbul','Fatih','Sahil Yolu No:62 D:9','2025-03-21'),
('Seda','Aksoy','Female','1985-07-06','istanbul045@mail.com','05550000045','İstanbul','Üsküdar','İnönü Cd. No:3 D:15','2023-07-24'),
('Ali','Sezer','Male','1974-07-25','istanbul046@mail.com','05560000046','İstanbul','Pendik','Papatya Sk. No:34 D:12','2023-05-21'),
('Nehir','Taş','Female','1981-07-30','istanbul047@mail.com','05570000047','İstanbul','Esenyurt','Fatih Sk. No:113 D:18','2024-09-11'),
('Tolga','Erdoğan','Male','1965-05-09','istanbul048@mail.com','05580000048','İstanbul','Fatih','Ortaköy Cd. No:77 D:4','2023-10-03'),
('Ece','Arslan','Female','2004-11-29','istanbul049@mail.com','05590000049','İstanbul','Bakırköy','Ortaköy Cd. No:40 D:9','2024-07-31'),
('Tolga','Kurt','Male','1997-03-11','istanbul050@mail.com','05600000050','İstanbul','Üsküdar','Lale Sk. No:176 D:9','2025-11-01'),
('Beyza','Ünal','Female','2005-08-12','istanbul051@mail.com','05610000051','İstanbul','Kadıköy','İnönü Cd. No:163 D:14','2024-07-20'),
('Ahmet','Yılmaz','Male','1979-12-18','istanbul052@mail.com','05620000052','İstanbul','Şişli','Papatya Sk. No:42 D:15','2025-05-25'),
('Gül','Yılmaz','Female','1970-01-07','istanbul053@mail.com','05630000053','İstanbul','Bakırköy','Barbaros Blv. No:140 D:2','2025-01-26'),
('Gökhan','Dinç','Male','1971-08-24','istanbul054@mail.com','05640000054','İstanbul','Ataşehir','Barbaros Blv. No:11 D:10','2025-01-16'),
('Nehir','Demir','Female','2005-04-28','istanbul055@mail.com','05650000055','İstanbul','Üsküdar','Lale Sk. No:175 D:8','2023-07-30'),
('Ömer','Dinç','Male','2004-08-29','istanbul056@mail.com','05660000056','İstanbul','Ataşehir','Abide-i Hürriyet Cd. No:192 D:5','2024-04-29'),
('Şeyma','Doğan','Female','2000-11-18','istanbul057@mail.com','05670000057','İstanbul','Şişli','Bahariye Cd. No:7 D:6','2024-11-11'),
('Berk','Yıldırım','Male','2000-12-26','istanbul058@mail.com','05680000058','İstanbul','Fatih','Menekşe Sk. No:69 D:6','2023-08-10'),
('Esra','Demir','Female','2003-07-08','istanbul059@mail.com','05690000059','İstanbul','Maltepe','Menekşe Sk. No:52 D:15','2024-12-17'),
('Burak','Güler','Male','1975-01-01','istanbul060@mail.com','05700000060','İstanbul','Kadıköy','Lale Sk. No:103 D:11','2024-07-24'),
('Şeyma','Çelik','Female','1999-09-10','istanbul061@mail.com','05710000061','İstanbul','Esenyurt','Mimar Sinan Cd. No:165 D:17','2025-03-29'),
('İsmail','Sezer','Male','1979-11-09','istanbul062@mail.com','05720000062','İstanbul','Kadıköy','Gazi Cd. No:67 D:6','2024-06-27'),
('Elif','Koç','Female','1991-10-06','istanbul063@mail.com','05730000063','İstanbul','Ataşehir','Mimar Sinan Cd. No:187 D:11','2025-06-12'),
('Tolga','Köse','Male','1970-03-10','istanbul064@mail.com','05740000064','İstanbul','Ataşehir','Doğan Araslı Blv. No:49 D:9','2023-04-01'),
('Sıla','Sarı','Female','1965-01-28','istanbul065@mail.com','05750000065','İstanbul','Pendik','Ortaköy Cd. No:176 D:7','2025-01-15'),
('Kaan','Çelik','Male','1994-10-18','istanbul066@mail.com','05760000066','İstanbul','Üsküdar','Abide-i Hürriyet Cd. No:81 D:4','2024-09-07'),
('Hülya','Aksoy','Female','1994-12-01','istanbul067@mail.com','05770000067','İstanbul','Ataşehir','Sahil Yolu No:104 D:10','2023-09-18'),
('Can','Yıldırım','Male','1994-10-30','istanbul068@mail.com','05780000068','İstanbul','Ataşehir','Fatih Sk. No:158 D:19','2024-09-08'),
('Esra','Dinç','Female','2002-05-26','istanbul069@mail.com','05790000069','İstanbul','Kadıköy','Şehitler Cd. No:74 D:7','2025-05-30'),
('Berk','Karataş','Male','1992-03-19','istanbul070@mail.com','05800000070','İstanbul','Fatih','Sahil Yolu No:120 D:15','2025-06-24'),
('Selin','Kurt','Female','1987-12-07','istanbul071@mail.com','05810000071','İstanbul','Maltepe','Fatih Sk. No:169 D:3','2024-08-04'),
('Furkan','Ateş','Male','1980-01-14','istanbul072@mail.com','05820000072','İstanbul','Bakırköy','Menekşe Sk. No:173 D:10','2024-04-05'),
('Cansu','Karaca','Female','1971-08-12','istanbul073@mail.com','05830000073','İstanbul','Kadıköy','Cumhuriyet Cd. No:63 D:16','2023-05-30'),
('Okan','Yıldırım','Male','2004-10-01','istanbul074@mail.com','05840000074','İstanbul','Fatih','Doğan Araslı Blv. No:50 D:13','2025-10-09'),
('Esra','Taş','Female','1971-08-15','istanbul075@mail.com','05850000075','İstanbul','Fatih','Atatürk Cd. No:193 D:4','2025-05-20'),
('Kerem','Polat','Male','2001-01-26','istanbul076@mail.com','05860000076','İstanbul','Kartal','Teşvikiye Cd. No:119 D:2','2024-05-25'),
('Eylül','Arslan','Female','1985-06-23','istanbul077@mail.com','05870000077','İstanbul','Şişli','Moda Cd. No:171 D:17','2024-10-11'),
('Barış','Kara','Male','1992-06-25','istanbul078@mail.com','05880000078','İstanbul','Kartal','Teşvikiye Cd. No:110 D:18','2025-07-02'),
('Nehir','Doğan','Female','1998-05-12','istanbul079@mail.com','05890000079','İstanbul','Maltepe','Moda Cd. No:67 D:8','2024-07-21'),
('Barış','Erdoğan','Male','1986-09-27','istanbul080@mail.com','05900000080','İstanbul','Fatih','Menekşe Sk. No:71 D:15','2023-06-08'),
('Sıla','Şimşek','Female','1975-07-09','istanbul081@mail.com','05910000081','İstanbul','Esenyurt','Sahil Yolu No:82 D:18','2023-06-15'),
('Murat','Yıldız','Male','1975-05-17','istanbul082@mail.com','05920000082','İstanbul','Ataşehir','Barbaros Blv. No:181 D:7','2023-05-12'),
('Ceren','Yıldırım','Female','1979-11-05','istanbul083@mail.com','05930000083','İstanbul','Pendik','Moda Cd. No:107 D:2','2024-02-28'),
('Doğukan','Yıldırım','Male','1982-06-22','istanbul084@mail.com','05940000084','İstanbul','Sarıyer','Atatürk Cd. No:196 D:19','2025-02-18'),
('Beyza','Yılmaz','Female','1980-10-12','istanbul085@mail.com','05950000085','İstanbul','Esenyurt','Halaskargazi Cd. No:108 D:18','2024-03-27'),
('Onur','Güler','Male','1977-03-30','istanbul086@mail.com','05960000086','İstanbul','Ataşehir','Rıhtım Cd. No:8 D:13','2024-11-19'),
('Selin','Aslan','Female','1997-06-26','istanbul087@mail.com','05970000087','İstanbul','Şişli','Moda Cd. No:33 D:20','2025-12-29'),
('Mehmet','Aslan','Male','1991-07-21','istanbul088@mail.com','05980000088','İstanbul','Sarıyer','Atatürk Cd. No:22 D:14','2023-10-05'),
('Şeyma','Güneş','Female','1973-02-25','istanbul089@mail.com','05990000089','İstanbul','Kadıköy','Papatya Sk. No:98 D:11','2024-03-09'),
('Okan','Kılıç','Male','1980-02-21','istanbul090@mail.com','05100000090','İstanbul','Ataşehir','Papatya Sk. No:193 D:14','2024-05-31'),
('Rabia','Aydın','Female','1986-02-05','istanbul091@mail.com','05110000091','İstanbul','Kadıköy','Ortaköy Cd. No:14 D:12','2024-04-04'),
('Sercan','Çelik','Male','2000-01-17','istanbul092@mail.com','05120000092','İstanbul','Fatih','Cumhuriyet Cd. No:194 D:1','2024-05-21'),
('İrem','Kaya','Female','1992-11-14','istanbul093@mail.com','05130000093','İstanbul','Şişli','Menekşe Sk. No:33 D:16','2023-08-23'),
('Gökhan','Kurt','Male','1985-11-11','istanbul094@mail.com','05140000094','İstanbul','Kartal','Papatya Sk. No:197 D:12','2023-12-10'),
('Yasemin','Uçar','Female','1998-07-21','istanbul095@mail.com','05150000095','İstanbul','Kartal','Gazi Cd. No:42 D:10','2023-08-10'),
('Gökhan','Kaya','Male','1978-12-30','istanbul096@mail.com','05160000096','İstanbul','Sarıyer','Halaskargazi Cd. No:102 D:7','2023-06-05'),
('Aslı','Taş','Female','1969-07-28','istanbul097@mail.com','05170000097','İstanbul','Kartal','Şehitler Cd. No:176 D:20','2023-09-05'),
('Berk','Özkan','Male','2000-02-09','istanbul098@mail.com','05180000098','İstanbul','Kadıköy','Mimar Sinan Cd. No:137 D:14','2025-01-28'),
('Zeynep','Köse','Female','1994-01-18','istanbul099@mail.com','05190000099','İstanbul','Üsküdar','Atatürk Cd. No:108 D:16','2023-08-05'),
('Kaan','Özdemir','Male','1993-07-06','istanbul100@mail.com','05200000100','İstanbul','Maltepe','Barbaros Blv. No:112 D:6','2025-12-04'),
('Hande','Çetin','Female','1992-08-18','istanbul101@mail.com','05210000101','İstanbul','Pendik','Rıhtım Cd. No:120 D:14','2024-07-03'),
('Hakan','Taş','Male','2002-04-07','istanbul102@mail.com','05220000102','İstanbul','Bakırköy','Papatya Sk. No:116 D:8','2025-08-09'),
('Aslı','Ateş','Female','1994-12-22','istanbul103@mail.com','05230000103','İstanbul','Ataşehir','Sahil Yolu No:8 D:16','2024-10-27'),
('Emre','Bulut','Male','1974-07-08','istanbul104@mail.com','05240000104','İstanbul','Üsküdar','Papatya Sk. No:88 D:9','2024-07-19'),
('Gül','Yılmaz','Female','1988-03-05','istanbul105@mail.com','05250000105','İstanbul','Beşiktaş','İnönü Cd. No:62 D:14','2025-09-27'),
('Uğur','Taş','Male','1995-12-24','istanbul106@mail.com','05260000106','İstanbul','Maltepe','Rıhtım Cd. No:115 D:1','2023-07-10'),
('Melis','Güler','Female','1983-02-21','istanbul107@mail.com','05270000107','İstanbul','Kartal','Menekşe Sk. No:79 D:19','2025-01-25'),
('Onur','Dinç','Male','1988-10-25','istanbul108@mail.com','05280000108','İstanbul','Üsküdar','Bahariye Cd. No:191 D:18','2024-11-08'),
('Tuğçe','Güneş','Female','1977-02-25','istanbul109@mail.com','05290000109','İstanbul','Esenyurt','Papatya Sk. No:60 D:4','2024-01-30'),
('Hakan','Arslan','Male','1998-04-29','istanbul110@mail.com','05300000110','İstanbul','Pendik','Fatih Sk. No:50 D:7','2025-09-18'),
('Ece','Karataş','Female','1999-02-07','istanbul111@mail.com','05310000111','İstanbul','Pendik','Abide-i Hürriyet Cd. No:73 D:4','2024-02-02'),
('Burak','Güler','Male','1981-03-10','istanbul112@mail.com','05320000112','İstanbul','Şişli','Şehitler Cd. No:4 D:18','2023-09-17'),
('Ece','Demir','Female','1967-06-13','istanbul113@mail.com','05330000113','İstanbul','Pendik','Şehitler Cd. No:179 D:5','2025-10-02'),
('Mustafa','Yılmaz','Male','1990-10-02','istanbul114@mail.com','05340000114','İstanbul','Esenyurt','Rıhtım Cd. No:123 D:15','2024-11-28'),
('Büşra','Şahin','Female','1976-04-29','istanbul115@mail.com','05350000115','İstanbul','Maltepe','Gazi Cd. No:17 D:13','2025-10-04'),
('Ali','Özkan','Male','1993-03-27','istanbul116@mail.com','05360000116','İstanbul','Fatih','Cumhuriyet Cd. No:39 D:5','2024-09-14'),
('Zeynep','Taş','Female','1970-04-25','istanbul117@mail.com','05370000117','İstanbul','Pendik','Bahariye Cd. No:156 D:20','2024-04-07'),
('Barış','Erdoğan','Male','1982-01-24','istanbul118@mail.com','05380000118','İstanbul','Maltepe','Moda Cd. No:77 D:19','2025-05-28'),
('Melis','Özkan','Female','1992-11-09','istanbul119@mail.com','05390000119','İstanbul','Kadıköy','Abide-i Hürriyet Cd. No:190 D:4','2024-03-01'),
('Sercan','Kurt','Male','1976-11-14','istanbul120@mail.com','05400000120','İstanbul','Fatih','İnönü Cd. No:41 D:8','2023-12-22'),
('Gül','Çelik','Female','1972-01-09','istanbul121@mail.com','05410000121','İstanbul','Kadıköy','Bahariye Cd. No:116 D:20','2025-08-20'),
('Burak','Demir','Male','1975-05-21','istanbul122@mail.com','05420000122','İstanbul','Esenyurt','Şehitler Cd. No:180 D:15','2023-05-26'),
('Selin','Güler','Female','1976-11-13','istanbul123@mail.com','05430000123','İstanbul','Fatih','Doğan Araslı Blv. No:170 D:7','2025-05-20'),
('Mustafa','Sezer','Male','1975-02-01','istanbul124@mail.com','05440000124','İstanbul','Fatih','Barbaros Blv. No:69 D:5','2023-05-27'),
('Elif','Doğan','Female','2000-07-22','istanbul125@mail.com','05450000125','İstanbul','Esenyurt','Abide-i Hürriyet Cd. No:192 D:19','2024-08-14'),
('Okan','Arslan','Male','1986-01-10','istanbul126@mail.com','05460000126','İstanbul','Kartal','Şehitler Cd. No:180 D:13','2024-07-11'),
('Hülya','Sezer','Female','1987-02-25','istanbul127@mail.com','05470000127','İstanbul','Maltepe','İnönü Cd. No:154 D:2','2025-06-03'),
('Eren','Kılıç','Male','1992-01-31','istanbul128@mail.com','05480000128','İstanbul','Esenyurt','Atatürk Cd. No:24 D:8','2023-02-12'),
('Deniz','Çetin','Female','1990-11-07','istanbul129@mail.com','05490000129','İstanbul','Kadıköy','Fatih Sk. No:121 D:17','2025-06-24'),
('Cem','Çetin','Male','1973-02-21','istanbul130@mail.com','05500000130','İstanbul','Sarıyer','Bahariye Cd. No:163 D:16','2023-07-06'),
('Beyza','Yalçın','Female','1983-04-27','istanbul131@mail.com','05510000131','İstanbul','Üsküdar','Sahil Yolu No:172 D:4','2023-11-26'),
('Hakan','Yıldırım','Male','1996-02-13','istanbul132@mail.com','05520000132','İstanbul','Maltepe','Şehitler Cd. No:170 D:13','2023-03-17'),
('Naz','Aydın','Female','1979-02-10','istanbul133@mail.com','05530000133','İstanbul','Esenyurt','Sahil Yolu No:30 D:13','2025-11-19'),
('Doğukan','Yılmaz','Male','1994-07-03','istanbul134@mail.com','05540000134','İstanbul','Pendik','Moda Cd. No:106 D:2','2024-01-20'),
('Hülya','Özdemir','Female','1992-12-06','istanbul135@mail.com','05550000135','İstanbul','Maltepe','Moda Cd. No:195 D:2','2024-02-21'),
('Serkan','Dinç','Male','1970-11-17','istanbul136@mail.com','05560000136','İstanbul','Esenyurt','Moda Cd. No:179 D:16','2023-09-06'),
('Ayşe','Uçar','Female','2000-11-08','istanbul137@mail.com','05570000137','İstanbul','Beşiktaş','Fatih Sk. No:80 D:18','2023-01-29'),
('Uğur','Yıldırım','Male','1969-03-08','istanbul138@mail.com','05580000138','İstanbul','Beşiktaş','Gazi Cd. No:119 D:4','2023-11-12'),
('Beyza','Şimşek','Female','1987-10-30','istanbul139@mail.com','05590000139','İstanbul','Kartal','Papatya Sk. No:107 D:16','2025-08-25'),
('Kerem','Güneş','Male','1989-09-23','istanbul140@mail.com','05600000140','İstanbul','Şişli','Halaskargazi Cd. No:49 D:20','2025-11-06'),
('Nisa','Öztürk','Female','2003-10-05','istanbul141@mail.com','05610000141','İstanbul','Bakırköy','Papatya Sk. No:198 D:14','2024-11-27'),
('Cem','Köse','Male','1976-12-26','istanbul142@mail.com','05620000142','İstanbul','Kadıköy','Şehitler Cd. No:186 D:10','2025-09-29'),
('Şeyma','Yıldız','Female','1985-01-12','istanbul143@mail.com','05630000143','İstanbul','Pendik','Rıhtım Cd. No:89 D:11','2025-02-11'),
('Okan','Kılıç','Male','2004-01-04','istanbul144@mail.com','05640000144','İstanbul','Beşiktaş','Menekşe Sk. No:147 D:13','2024-04-23'),
('Şeyma','Yıldırım','Female','1966-12-17','istanbul145@mail.com','05650000145','İstanbul','Üsküdar','Rıhtım Cd. No:181 D:13','2025-03-01'),
('İsmail','Yıldız','Male','1987-03-22','istanbul146@mail.com','05660000146','İstanbul','Kadıköy','Barbaros Blv. No:129 D:19','2024-11-10'),
('Şeyma','Koç','Female','2004-03-19','istanbul147@mail.com','05670000147','İstanbul','Maltepe','Gazi Cd. No:135 D:15','2023-02-01'),
('Eren','Yıldız','Male','1983-05-24','istanbul148@mail.com','05680000148','İstanbul','Fatih','Barbaros Blv. No:20 D:16','2024-06-26'),
('Gamze','Ateş','Female','1996-01-28','istanbul149@mail.com','05690000149','İstanbul','Ataşehir','İnönü Cd. No:85 D:18','2025-02-17'),
('Hakan','Bulut','Male','2004-02-19','istanbul150@mail.com','05700000150','İstanbul','Pendik','Cumhuriyet Cd. No:159 D:3','2024-04-25'),
('Hande','Şimşek','Female','1975-03-17','istanbul151@mail.com','05710000151','İstanbul','Kartal','İnönü Cd. No:112 D:4','2023-07-25'),
('Okan','Doğan','Male','1996-02-18','istanbul152@mail.com','05720000152','İstanbul','Esenyurt','Atatürk Cd. No:12 D:11','2023-04-25'),
('Melis','Yalçın','Female','1981-10-25','istanbul153@mail.com','05730000153','İstanbul','Ataşehir','Barbaros Blv. No:63 D:17','2025-04-23'),
('Gökhan','Polat','Male','1972-08-17','istanbul154@mail.com','05740000154','İstanbul','Şişli','İnönü Cd. No:157 D:13','2024-05-08'),
('Beyza','Karataş','Female','1971-06-03','istanbul155@mail.com','05750000155','İstanbul','Beşiktaş','Moda Cd. No:164 D:9','2025-07-30'),
('Serkan','Yılmaz','Male','2005-04-28','istanbul156@mail.com','05760000156','İstanbul','Maltepe','Şehitler Cd. No:174 D:18','2023-11-20'),
('Zeynep','Kara','Female','1980-07-02','istanbul157@mail.com','05770000157','İstanbul','Sarıyer','Şehitler Cd. No:164 D:14','2024-05-27'),
('Okan','Aksoy','Male','1973-12-08','istanbul158@mail.com','05780000158','İstanbul','Ataşehir','Rıhtım Cd. No:28 D:8','2025-02-20'),
('Aslı','Yalçın','Female','1990-10-14','istanbul159@mail.com','05790000159','İstanbul','Esenyurt','Şehitler Cd. No:6 D:13','2024-07-16'),
('Mehmet','Özkan','Male','2003-10-22','istanbul160@mail.com','05800000160','İstanbul','Fatih','Cumhuriyet Cd. No:156 D:16','2024-08-09'),
('Deniz','Güler','Female','1992-03-26','istanbul161@mail.com','05810000161','İstanbul','Üsküdar','Menekşe Sk. No:163 D:7','2024-05-28'),
('İsmail','Öztürk','Male','1993-03-08','istanbul162@mail.com','05820000162','İstanbul','Bakırköy','Cumhuriyet Cd. No:80 D:15','2023-03-10'),
('Aslı','Özdemir','Female','1997-11-07','istanbul163@mail.com','05830000163','İstanbul','Şişli','İnönü Cd. No:76 D:11','2025-04-30'),
('Emre','Karaca','Male','1970-12-06','istanbul164@mail.com','05840000164','İstanbul','Pendik','Mimar Sinan Cd. No:136 D:17','2024-07-12'),
('Rabia','Doğan','Female','1976-07-12','istanbul165@mail.com','05850000165','İstanbul','Maltepe','Şehitler Cd. No:192 D:11','2023-08-24'),
('Okan','Çelik','Male','1971-04-26','istanbul166@mail.com','05860000166','İstanbul','Beşiktaş','Halaskargazi Cd. No:143 D:12','2023-07-04'),
('Cansu','Aslan','Female','1965-08-17','istanbul167@mail.com','05870000167','İstanbul','Esenyurt','Ortaköy Cd. No:32 D:15','2025-01-24'),
('İsmail','Ünal','Male','1991-03-23','istanbul168@mail.com','05880000168','İstanbul','Ataşehir','Mimar Sinan Cd. No:28 D:8','2025-08-23'),
('Ayşe','Ateş','Female','2004-08-31','istanbul169@mail.com','05890000169','İstanbul','Pendik','Sahil Yolu No:157 D:8','2023-05-10'),
('Sercan','Güneş','Male','2005-10-17','istanbul170@mail.com','05900000170','İstanbul','Kartal','Şehitler Cd. No:167 D:14','2023-08-27'),
('Seda','Demir','Female','1966-09-02','istanbul171@mail.com','05910000171','İstanbul','Esenyurt','Rıhtım Cd. No:30 D:4','2024-04-25'),
('Volkan','Sezer','Male','1971-02-01','istanbul172@mail.com','05920000172','İstanbul','Ataşehir','Moda Cd. No:95 D:18','2025-05-08'),
('Aslı','Yıldız','Female','2004-09-19','istanbul173@mail.com','05930000173','İstanbul','Ataşehir','Gazi Cd. No:126 D:20','2025-04-15'),
('Serkan','Demir','Male','1995-12-19','istanbul174@mail.com','05940000174','İstanbul','Üsküdar','Lale Sk. No:114 D:15','2024-04-28'),
('Şeyma','Özdemir','Female','1969-06-16','istanbul175@mail.com','05950000175','İstanbul','Fatih','Mimar Sinan Cd. No:140 D:12','2023-05-05'),
('Yusuf','Çetin','Male','1973-07-07','istanbul176@mail.com','05960000176','İstanbul','Bakırköy','Moda Cd. No:24 D:7','2023-02-13'),
('Elif','Eren','Female','1975-12-05','istanbul177@mail.com','05970000177','İstanbul','Şişli','Doğan Araslı Blv. No:53 D:3','2024-02-29'),
('Gökhan','Kurt','Male','2001-06-22','istanbul178@mail.com','05980000178','İstanbul','Beşiktaş','Sahil Yolu No:199 D:5','2023-01-06'),
('Ece','Yıldız','Female','1970-10-31','istanbul179@mail.com','05990000179','İstanbul','Pendik','Papatya Sk. No:45 D:4','2023-02-22'),
('Murat','Yılmaz','Male','1981-01-26','istanbul180@mail.com','05100000180','İstanbul','Beşiktaş','Doğan Araslı Blv. No:83 D:1','2023-12-23'),
('Ece','Şahin','Female','1970-09-08','istanbul181@mail.com','05110000181','İstanbul','Kartal','Bahariye Cd. No:135 D:4','2023-05-11'),
('Onur','Kara','Male','1999-11-26','istanbul182@mail.com','05120000182','İstanbul','Üsküdar','Teşvikiye Cd. No:152 D:4','2025-07-14'),
('Hülya','Güler','Female','1992-08-04','istanbul183@mail.com','05130000183','İstanbul','Kadıköy','Teşvikiye Cd. No:78 D:15','2023-03-05'),
('Ahmet','Avcı','Male','2003-01-04','istanbul184@mail.com','05140000184','İstanbul','Ataşehir','Bahariye Cd. No:176 D:4','2025-10-01'),
('Sıla','Kara','Female','1968-04-19','istanbul185@mail.com','05150000185','İstanbul','Bakırköy','Sahil Yolu No:156 D:5','2023-05-15'),
('Murat','Çetin','Male','1993-01-02','istanbul186@mail.com','05160000186','İstanbul','Fatih','Doğan Araslı Blv. No:141 D:11','2025-02-19'),
('Yasemin','Erdoğan','Female','1978-03-25','istanbul187@mail.com','05170000187','İstanbul','Maltepe','Teşvikiye Cd. No:155 D:14','2023-07-23'),
('Berk','Arslan','Male','2003-04-04','istanbul188@mail.com','05180000188','İstanbul','Fatih','Ortaköy Cd. No:185 D:7','2025-05-30'),
('Naz','Güler','Female','1983-07-25','istanbul189@mail.com','05190000189','İstanbul','Üsküdar','Moda Cd. No:103 D:14','2023-07-14'),
('Hakan','Sarı','Male','1979-01-08','istanbul190@mail.com','05200000190','İstanbul','Fatih','Papatya Sk. No:96 D:5','2025-08-29'),
('Zeynep','Aydın','Female','2002-04-24','istanbul191@mail.com','05210000191','İstanbul','Bakırköy','İnönü Cd. No:111 D:4','2025-02-02'),
('Berk','Öztürk','Male','1989-12-16','istanbul192@mail.com','05220000192','İstanbul','Kadıköy','Doğan Araslı Blv. No:144 D:18','2024-11-06'),
('Selin','Arslan','Female','1983-06-06','istanbul193@mail.com','05230000193','İstanbul','Üsküdar','Bahariye Cd. No:185 D:2','2024-08-12'),
('Tolga','Aksoy','Male','1980-10-10','istanbul194@mail.com','05240000194','İstanbul','Bakırköy','Doğan Araslı Blv. No:130 D:7','2023-11-13'),
('Selin','Avcı','Female','1975-01-23','istanbul195@mail.com','05250000195','İstanbul','Bakırköy','Mimar Sinan Cd. No:143 D:12','2023-08-24'),
('Barış','Çetin','Male','1990-10-03','istanbul196@mail.com','05260000196','İstanbul','Beşiktaş','Bahariye Cd. No:144 D:20','2023-02-23'),
('Yasemin','Çetin','Female','1966-04-20','istanbul197@mail.com','05270000197','İstanbul','Şişli','Papatya Sk. No:180 D:10','2024-11-26'),
('Ömer','Yılmaz','Male','1973-02-20','istanbul198@mail.com','05280000198','İstanbul','Şişli','Doğan Araslı Blv. No:169 D:13','2023-05-23'),
('Seda','Kaya','Female','1969-02-12','istanbul199@mail.com','05290000199','İstanbul','Kartal','Teşvikiye Cd. No:56 D:13','2025-05-09'),
('Okan','Eren','Male','1972-01-23','istanbul200@mail.com','05300000200','İstanbul','Üsküdar','Şehitler Cd. No:185 D:11','2023-06-23'),
('Nehir','Şahin','Female','1971-12-25','istanbul201@mail.com','05310000201','İstanbul','Şişli','Abide-i Hürriyet Cd. No:13 D:3','2024-07-11'),
('Okan','Sarı','Male','1986-10-15','istanbul202@mail.com','05320000202','İstanbul','Sarıyer','Moda Cd. No:107 D:9','2024-03-17'),
('Deniz','Köse','Female','1970-02-08','istanbul203@mail.com','05330000203','İstanbul','Üsküdar','Bahariye Cd. No:29 D:10','2025-09-23'),
('Furkan','Aksoy','Male','1967-01-15','istanbul204@mail.com','05340000204','İstanbul','Beşiktaş','Halaskargazi Cd. No:154 D:2','2023-01-16'),
('İrem','Aksoy','Female','1974-06-23','istanbul205@mail.com','05350000205','İstanbul','Şişli','Papatya Sk. No:75 D:11','2023-09-03'),
('Mehmet','Bulut','Male','1998-07-06','istanbul206@mail.com','05360000206','İstanbul','Ataşehir','Fatih Sk. No:34 D:13','2025-12-26'),
('Sıla','Güler','Female','1987-06-11','istanbul207@mail.com','05370000207','İstanbul','Pendik','Mimar Sinan Cd. No:19 D:13','2023-03-28'),
('Kaan','Kaya','Male','1985-08-16','istanbul208@mail.com','05380000208','İstanbul','Bakırköy','Sahil Yolu No:148 D:14','2025-04-08'),
('Sıla','Yıldırım','Female','1977-12-27','istanbul209@mail.com','05390000209','İstanbul','Bakırköy','Halaskargazi Cd. No:6 D:11','2023-12-18'),
('Berk','Ateş','Male','1985-08-22','istanbul210@mail.com','05400000210','İstanbul','Kartal','Mimar Sinan Cd. No:23 D:14','2023-08-05'),
('Derya','Sarı','Female','1991-06-02','istanbul211@mail.com','05410000211','İstanbul','Ataşehir','Teşvikiye Cd. No:21 D:13','2024-09-27'),
('Eren','Eren','Male','1974-12-10','istanbul212@mail.com','05420000212','İstanbul','Üsküdar','Fatih Sk. No:20 D:17','2023-08-22'),
('Hülya','Köse','Female','1973-09-12','istanbul213@mail.com','05430000213','İstanbul','Üsküdar','Mimar Sinan Cd. No:187 D:5','2024-04-28'),
('Mustafa','Yıldız','Male','1976-06-25','istanbul214@mail.com','05440000214','İstanbul','Beşiktaş','Fatih Sk. No:155 D:5','2023-06-04'),
('Büşra','Bulut','Female','1985-10-24','istanbul215@mail.com','05450000215','İstanbul','Sarıyer','Doğan Araslı Blv. No:115 D:19','2024-10-23'),
('Kubilay','Kılıç','Male','1971-10-10','istanbul216@mail.com','05460000216','İstanbul','Maltepe','İnönü Cd. No:121 D:15','2024-09-12'),
('Cansu','Çetin','Female','1991-07-13','istanbul217@mail.com','05470000217','İstanbul','Kadıköy','Mimar Sinan Cd. No:130 D:3','2024-09-27'),
('Okan','Kara','Male','1966-09-09','istanbul218@mail.com','05480000218','İstanbul','Kadıköy','Mimar Sinan Cd. No:74 D:3','2023-07-04'),
('Yasemin','Uçar','Female','1987-09-30','istanbul219@mail.com','05490000219','İstanbul','Ataşehir','Moda Cd. No:149 D:18','2023-03-26'),
('Okan','Özkan','Male','1994-03-29','istanbul220@mail.com','05500000220','İstanbul','Beşiktaş','Sahil Yolu No:155 D:16','2025-10-23'),
('Seda','Şahin','Female','1985-03-18','istanbul221@mail.com','05510000221','İstanbul','Bakırköy','Sahil Yolu No:183 D:3','2025-10-30'),
('Sercan','Polat','Male','1966-10-04','istanbul222@mail.com','05520000222','İstanbul','Beşiktaş','Moda Cd. No:113 D:17','2025-12-06'),
('Yasemin','Doğan','Female','1981-04-29','istanbul223@mail.com','05530000223','İstanbul','Üsküdar','Şehitler Cd. No:100 D:14','2024-11-23'),
('İsmail','Uçar','Male','1967-05-08','istanbul224@mail.com','05540000224','İstanbul','Fatih','Sahil Yolu No:17 D:11','2023-07-13'),
('Gül','Kaplan','Female','1977-09-30','istanbul225@mail.com','05550000225','İstanbul','Esenyurt','Abide-i Hürriyet Cd. No:39 D:11','2023-06-16'),
('Gökhan','Yıldız','Male','1980-09-10','istanbul226@mail.com','05560000226','İstanbul','Esenyurt','Halaskargazi Cd. No:34 D:20','2023-06-23'),
('Melis','Dinç','Female','1981-11-24','istanbul227@mail.com','05570000227','İstanbul','Fatih','Sahil Yolu No:33 D:17','2023-07-11'),
('Sercan','Sarı','Male','1987-10-24','istanbul228@mail.com','05580000228','İstanbul','Üsküdar','Atatürk Cd. No:93 D:10','2024-01-05'),
('İrem','Eren','Female','1999-05-15','istanbul229@mail.com','05590000229','İstanbul','Maltepe','Lale Sk. No:58 D:5','2023-11-14'),
('Ali','Şimşek','Male','2002-11-18','istanbul230@mail.com','05600000230','İstanbul','Bakırköy','Teşvikiye Cd. No:198 D:18','2025-12-14'),
('Elif','Eren','Female','2004-04-24','istanbul231@mail.com','05610000231','İstanbul','Sarıyer','Barbaros Blv. No:153 D:13','2023-11-12'),
('Emre','Polat','Male','2002-04-17','istanbul232@mail.com','05620000232','İstanbul','Kartal','Abide-i Hürriyet Cd. No:43 D:15','2023-03-31'),
('Ceren','Özdemir','Female','1995-05-05','istanbul233@mail.com','05630000233','İstanbul','Kartal','Menekşe Sk. No:114 D:20','2024-08-06'),
('Barış','Kara','Male','1975-07-01','istanbul234@mail.com','05640000234','İstanbul','Pendik','Menekşe Sk. No:80 D:16','2024-02-02'),
('Tuğçe','Özkan','Female','1984-10-06','istanbul235@mail.com','05650000235','İstanbul','Maltepe','Şehitler Cd. No:98 D:17','2025-12-16'),
('Kaan','Doğan','Male','2001-08-23','istanbul236@mail.com','05660000236','İstanbul','Beşiktaş','Abide-i Hürriyet Cd. No:36 D:9','2023-04-17'),
('Hande','Avcı','Female','2004-03-18','istanbul237@mail.com','05670000237','İstanbul','Üsküdar','Ortaköy Cd. No:27 D:17','2023-09-13'),
('Burak','Aydın','Male','1999-03-26','istanbul238@mail.com','05680000238','İstanbul','Şişli','Papatya Sk. No:116 D:17','2023-10-29'),
('Rabia','Sarı','Female','1969-02-11','istanbul239@mail.com','05690000239','İstanbul','Beşiktaş','Moda Cd. No:90 D:1','2025-04-29'),
('Ahmet','Aslan','Male','1987-07-09','istanbul240@mail.com','05700000240','İstanbul','Üsküdar','Menekşe Sk. No:99 D:3','2025-02-06'),
('Derya','Kaya','Female','1979-04-19','istanbul241@mail.com','05710000241','İstanbul','Bakırköy','Sahil Yolu No:38 D:5','2023-03-20'),
('Burak','Avcı','Male','1996-03-23','istanbul242@mail.com','05720000242','İstanbul','Şişli','Rıhtım Cd. No:115 D:20','2023-01-11'),
('Nehir','Aydın','Female','1965-11-08','istanbul243@mail.com','05730000243','İstanbul','Esenyurt','Lale Sk. No:39 D:18','2025-12-16'),
('Kaan','Arslan','Male','1999-10-26','istanbul244@mail.com','05740000244','İstanbul','Esenyurt','Menekşe Sk. No:78 D:4','2023-04-08'),
('Derya','Yıldırım','Female','1993-08-30','istanbul245@mail.com','05750000245','İstanbul','Sarıyer','Moda Cd. No:17 D:4','2025-10-20'),
('Tolga','Sezer','Male','1965-09-27','istanbul246@mail.com','05760000246','İstanbul','Fatih','Teşvikiye Cd. No:148 D:8','2023-10-22'),
('Melis','Sarı','Female','1965-01-26','istanbul247@mail.com','05770000247','İstanbul','Sarıyer','Mimar Sinan Cd. No:62 D:19','2025-05-03'),
('Emre','Aydın','Male','1988-06-25','istanbul248@mail.com','05780000248','İstanbul','Üsküdar','İnönü Cd. No:135 D:18','2025-11-05'),
('Cansu','Köse','Female','1989-11-10','istanbul249@mail.com','05790000249','İstanbul','Kadıköy','Halaskargazi Cd. No:121 D:2','2025-03-03'),
('Ömer','Ünal','Male','1998-07-11','istanbul250@mail.com','05800000250','İstanbul','Kadıköy','Mimar Sinan Cd. No:18 D:12','2024-05-08'),
('Nisa','Koç','Female','1999-08-11','istanbul251@mail.com','05810000251','İstanbul','Sarıyer','Sahil Yolu No:35 D:2','2024-12-22'),
('Uğur','Eren','Male','2001-06-29','istanbul252@mail.com','05820000252','İstanbul','Fatih','Fatih Sk. No:176 D:15','2025-09-07'),
('Hande','Polat','Female','2001-05-27','istanbul253@mail.com','05830000253','İstanbul','Şişli','İnönü Cd. No:184 D:15','2023-03-17'),
('Burak','Karaca','Male','1966-12-19','istanbul254@mail.com','05840000254','İstanbul','Beşiktaş','Cumhuriyet Cd. No:81 D:10','2025-11-21'),
('Esra','Sezer','Female','1986-03-28','istanbul255@mail.com','05850000255','İstanbul','Esenyurt','Cumhuriyet Cd. No:193 D:7','2024-08-08'),
('Ömer','Şahin','Male','2003-11-03','istanbul256@mail.com','05860000256','İstanbul','Fatih','Sahil Yolu No:70 D:4','2025-01-23'),
('Ceren','Aslan','Female','1998-05-06','istanbul257@mail.com','05870000257','İstanbul','Maltepe','Halaskargazi Cd. No:87 D:6','2025-10-13'),
('Halil','Bulut','Male','1981-06-24','istanbul258@mail.com','05880000258','İstanbul','Pendik','Papatya Sk. No:22 D:14','2023-06-11'),
('Ceren','Uçar','Female','2001-11-21','istanbul259@mail.com','05890000259','İstanbul','Şişli','Ortaköy Cd. No:76 D:11','2023-07-30'),
('Ali','Kılıç','Male','1994-08-25','istanbul260@mail.com','05900000260','İstanbul','Esenyurt','Şehitler Cd. No:115 D:20','2025-05-22'),
('Büşra','Kara','Female','1980-10-08','istanbul261@mail.com','05910000261','İstanbul','Maltepe','Cumhuriyet Cd. No:187 D:12','2025-06-09'),
('Serkan','Şahin','Male','1968-05-14','istanbul262@mail.com','05920000262','İstanbul','Fatih','Halaskargazi Cd. No:94 D:17','2023-11-24'),
('Ayşe','Yıldız','Female','2003-01-26','istanbul263@mail.com','05930000263','İstanbul','Sarıyer','Moda Cd. No:9 D:5','2023-05-18'),
('Kerem','Özdemir','Male','1981-03-31','istanbul264@mail.com','05940000264','İstanbul','Ataşehir','Doğan Araslı Blv. No:9 D:20','2023-11-11'),
('Selin','Kara','Female','1981-08-22','istanbul265@mail.com','05950000265','İstanbul','Üsküdar','Moda Cd. No:196 D:3','2023-10-09'),
('Furkan','Özdemir','Male','1982-11-09','istanbul266@mail.com','05960000266','İstanbul','Üsküdar','Papatya Sk. No:64 D:4','2023-02-23'),
('Nisa','Polat','Female','1987-05-22','istanbul267@mail.com','05970000267','İstanbul','Pendik','Halaskargazi Cd. No:144 D:4','2024-06-20'),
('Barış','Ünal','Male','1996-07-31','istanbul268@mail.com','05980000268','İstanbul','Maltepe','Lale Sk. No:157 D:10','2025-10-02'),
('İrem','Arslan','Female','1971-02-02','istanbul269@mail.com','05990000269','İstanbul','Bakırköy','Moda Cd. No:45 D:15','2023-06-29'),
('Berk','Kılıç','Male','1994-12-16','istanbul270@mail.com','05100000270','İstanbul','Üsküdar','İnönü Cd. No:141 D:18','2024-08-17'),
('Nehir','Aksoy','Female','2003-03-11','istanbul271@mail.com','05110000271','İstanbul','Şişli','Fatih Sk. No:93 D:17','2024-04-04'),
('Mustafa','Karaca','Male','2000-07-13','istanbul272@mail.com','05120000272','İstanbul','Şişli','Menekşe Sk. No:127 D:1','2025-01-09'),
('Gül','Özkan','Female','1981-07-20','istanbul273@mail.com','05130000273','İstanbul','Maltepe','Ortaköy Cd. No:34 D:20','2023-06-26'),
('Ali','Aksoy','Male','1982-11-11','istanbul274@mail.com','05140000274','İstanbul','Kartal','Rıhtım Cd. No:135 D:14','2025-04-18'),
('Rabia','Özkan','Female','1968-04-23','istanbul275@mail.com','05150000275','İstanbul','Şişli','Sahil Yolu No:165 D:3','2025-07-10'),
('Okan','Erdoğan','Male','1980-06-15','istanbul276@mail.com','05160000276','İstanbul','Şişli','Ortaköy Cd. No:164 D:19','2024-01-08'),
('Deniz','Öztürk','Female','1984-05-29','istanbul277@mail.com','05170000277','İstanbul','Pendik','Cumhuriyet Cd. No:32 D:17','2023-11-10'),
('Burak','Doğan','Male','1972-04-07','istanbul278@mail.com','05180000278','İstanbul','Üsküdar','Menekşe Sk. No:89 D:17','2024-08-04'),
('Şeyma','Aydın','Female','1976-03-29','istanbul279@mail.com','05190000279','İstanbul','Beşiktaş','Ortaköy Cd. No:71 D:5','2024-09-12'),
('Tolga','Sezer','Male','1969-03-11','istanbul280@mail.com','05200000280','İstanbul','Pendik','Fatih Sk. No:152 D:19','2023-11-12'),
('Büşra','Ateş','Female','1997-04-29','istanbul281@mail.com','05210000281','İstanbul','Sarıyer','Sahil Yolu No:145 D:2','2023-02-28'),
('Ali','Demir','Male','1993-10-10','istanbul282@mail.com','05220000282','İstanbul','Sarıyer','Papatya Sk. No:167 D:7','2025-05-03'),
('Yasemin','Kaya','Female','1987-05-05','istanbul283@mail.com','05230000283','İstanbul','Fatih','Ortaköy Cd. No:75 D:10','2025-09-16'),
('Kerem','Aslan','Male','1978-05-06','istanbul284@mail.com','05240000284','İstanbul','Maltepe','İnönü Cd. No:177 D:2','2023-11-20'),
('Naz','Yıldırım','Female','1986-09-21','istanbul285@mail.com','05250000285','İstanbul','Maltepe','Lale Sk. No:88 D:20','2023-10-22'),
('Hakan','Kılıç','Male','1997-12-08','istanbul286@mail.com','05260000286','İstanbul','Üsküdar','Halaskargazi Cd. No:34 D:12','2025-11-20'),
('Gül','Koç','Female','1979-04-26','istanbul287@mail.com','05270000287','İstanbul','Beşiktaş','Moda Cd. No:32 D:9','2025-07-09'),
('Kerem','Yıldız','Male','1969-05-06','istanbul288@mail.com','05280000288','İstanbul','Kadıköy','Şehitler Cd. No:99 D:20','2025-05-06'),
('Derya','Doğan','Female','2001-06-29','istanbul289@mail.com','05290000289','İstanbul','Üsküdar','Doğan Araslı Blv. No:185 D:11','2024-01-24'),
('Barış','Doğan','Male','1987-05-09','istanbul290@mail.com','05300000290','İstanbul','Pendik','Moda Cd. No:128 D:10','2025-10-15'),
('Ayşe','Aydın','Female','1982-08-22','istanbul291@mail.com','05310000291','İstanbul','Pendik','Moda Cd. No:62 D:7','2024-12-23'),
('Ahmet','Şahin','Male','1977-08-15','istanbul292@mail.com','05320000292','İstanbul','Maltepe','Abide-i Hürriyet Cd. No:168 D:16','2024-08-08'),
('Gül','Yılmaz','Female','2003-01-02','istanbul293@mail.com','05330000293','İstanbul','Bakırköy','Bahariye Cd. No:35 D:9','2025-01-19'),
('Barış','Aslan','Male','1981-06-01','istanbul294@mail.com','05340000294','İstanbul','Kadıköy','Halaskargazi Cd. No:14 D:19','2024-02-03'),
('Tuğçe','Dinç','Female','1977-12-12','istanbul295@mail.com','05350000295','İstanbul','Bakırköy','Halaskargazi Cd. No:130 D:15','2024-07-26'),
('Doğukan','Ateş','Male','1995-07-10','istanbul296@mail.com','05360000296','İstanbul','Sarıyer','Gazi Cd. No:33 D:4','2025-03-17'),
('Tuğçe','Eren','Female','1990-01-09','istanbul297@mail.com','05370000297','İstanbul','Üsküdar','Barbaros Blv. No:51 D:20','2025-11-08'),
('Yusuf','Köse','Male','1966-10-22','istanbul298@mail.com','05380000298','İstanbul','Kadıköy','Cumhuriyet Cd. No:36 D:11','2025-08-28'),
('Hülya','Güneş','Female','1971-09-07','istanbul299@mail.com','05390000299','İstanbul','Sarıyer','Teşvikiye Cd. No:36 D:11','2024-10-14'),
('Emre','Aslan','Male','1992-08-27','istanbul300@mail.com','05400000300','İstanbul','Kartal','Şehitler Cd. No:152 D:11','2025-11-04'),
('Rabia','Köse','Female','1988-11-17','ankara301@mail.com','05410000301','Ankara','Gölbaşı','Doğan Araslı Blv. No:77 D:16','2023-02-04'),
('Ömer','Eren','Male','1995-03-24','ankara302@mail.com','05420000302','Ankara','Keçiören','Bahariye Cd. No:150 D:10','2023-02-24'),
('Yasemin','Avcı','Female','1976-11-29','ankara303@mail.com','05430000303','Ankara','Mamak','Cumhuriyet Cd. No:150 D:16','2023-12-16'),
('Furkan','Ateş','Male','1999-10-01','ankara304@mail.com','05440000304','Ankara','Altındağ','Barbaros Blv. No:175 D:8','2023-03-06'),
('Aslı','Arslan','Female','1973-07-23','ankara305@mail.com','05450000305','Ankara','Çankaya','Moda Cd. No:81 D:14','2023-11-07'),
('Kaan','Kurt','Male','1983-05-30','ankara306@mail.com','05460000306','Ankara','Gölbaşı','Cumhuriyet Cd. No:181 D:5','2025-11-28'),
('İrem','Dinç','Female','1979-08-01','ankara307@mail.com','05470000307','Ankara','Gölbaşı','Teşvikiye Cd. No:97 D:11','2023-12-21'),
('Okan','Sezer','Male','1980-05-10','ankara308@mail.com','05480000308','Ankara','Sincan','Papatya Sk. No:157 D:16','2024-01-29'),
('Derya','Çetin','Female','1990-01-13','ankara309@mail.com','05490000309','Ankara','Etimesgut','Menekşe Sk. No:77 D:10','2024-02-29'),
('Halil','Bulut','Male','1979-03-23','ankara310@mail.com','05500000310','Ankara','Gölbaşı','Mimar Sinan Cd. No:144 D:9','2024-08-12'),
('Merve','Özkan','Female','1995-05-09','ankara311@mail.com','05510000311','Ankara','Altındağ','Halaskargazi Cd. No:89 D:5','2024-08-17'),
('Ahmet','Şimşek','Male','1997-01-13','ankara312@mail.com','05520000312','Ankara','Keçiören','Mimar Sinan Cd. No:114 D:9','2025-09-08'),
('İrem','Karaca','Female','2002-02-21','ankara313@mail.com','05530000313','Ankara','Etimesgut','Ortaköy Cd. No:179 D:9','2023-10-09'),
('Mustafa','Ateş','Male','1998-03-27','ankara314@mail.com','05540000314','Ankara','Mamak','Menekşe Sk. No:13 D:17','2024-04-07'),
('Hande','Güler','Female','1967-05-11','ankara315@mail.com','05550000315','Ankara','Keçiören','Bahariye Cd. No:85 D:16','2023-07-25'),
('İsmail','Öztürk','Male','1965-03-26','ankara316@mail.com','05560000316','Ankara','Yenimahalle','Bahariye Cd. No:168 D:16','2025-09-04'),
('Hande','Karaca','Female','1998-11-28','ankara317@mail.com','05570000317','Ankara','Etimesgut','Sahil Yolu No:74 D:2','2023-07-03'),
('Sercan','Özkan','Male','1975-06-02','ankara318@mail.com','05580000318','Ankara','Çankaya','Fatih Sk. No:107 D:6','2023-03-16'),
('Rabia','Aslan','Female','2000-05-06','ankara319@mail.com','05590000319','Ankara','Gölbaşı','Fatih Sk. No:192 D:10','2023-03-18'),
('Mehmet','Aksoy','Male','1990-06-24','ankara320@mail.com','05600000320','Ankara','Keçiören','Sahil Yolu No:73 D:15','2025-12-09'),
('Beyza','Öztürk','Female','2003-03-06','ankara321@mail.com','05610000321','Ankara','Gölbaşı','Papatya Sk. No:50 D:4','2024-11-08'),
('Emre','Güneş','Male','1994-01-30','ankara322@mail.com','05620000322','Ankara','Etimesgut','Fatih Sk. No:4 D:11','2024-08-27'),
('Aslı','Karaca','Female','1972-11-15','ankara323@mail.com','05630000323','Ankara','Altındağ','Bahariye Cd. No:132 D:11','2023-06-27'),
('Yusuf','Koç','Male','1973-04-16','ankara324@mail.com','05640000324','Ankara','Yenimahalle','Rıhtım Cd. No:83 D:8','2023-01-14'),
('Ece','Kaplan','Female','1975-07-26','ankara325@mail.com','05650000325','Ankara','Gölbaşı','Papatya Sk. No:85 D:10','2023-01-24'),
('Serkan','Özdemir','Male','1996-01-29','ankara326@mail.com','05660000326','Ankara','Mamak','Cumhuriyet Cd. No:171 D:4','2025-08-11'),
('Melis','Doğan','Female','1983-03-10','ankara327@mail.com','05670000327','Ankara','Etimesgut','Gazi Cd. No:164 D:10','2025-01-22'),
('Tolga','Güler','Male','1974-10-31','ankara328@mail.com','05680000328','Ankara','Yenimahalle','Rıhtım Cd. No:40 D:15','2025-02-04'),
('Ceren','Dinç','Female','2005-12-12','ankara329@mail.com','05690000329','Ankara','Gölbaşı','Ortaköy Cd. No:171 D:7','2024-05-21'),
('İsmail','Uçar','Male','2004-03-02','ankara330@mail.com','05700000330','Ankara','Keçiören','Teşvikiye Cd. No:115 D:17','2025-01-10'),
('Zeynep','Özkan','Female','1970-01-13','ankara331@mail.com','05710000331','Ankara','Çankaya','Ortaköy Cd. No:130 D:7','2023-11-03'),
('Emre','Kılıç','Male','2003-05-01','ankara332@mail.com','05720000332','Ankara','Gölbaşı','Gazi Cd. No:175 D:7','2025-09-28'),
('Zeynep','Köse','Female','1984-12-25','ankara333@mail.com','05730000333','Ankara','Çankaya','Moda Cd. No:34 D:17','2025-04-30'),
('Okan','Özkan','Male','1967-08-04','ankara334@mail.com','05740000334','Ankara','Gölbaşı','Şehitler Cd. No:186 D:1','2025-03-21'),
('Ece','Yılmaz','Female','1998-06-16','ankara335@mail.com','05750000335','Ankara','Mamak','Doğan Araslı Blv. No:19 D:2','2025-05-17'),
('Ömer','Çelik','Male','1989-04-11','ankara336@mail.com','05760000336','Ankara','Çankaya','İnönü Cd. No:121 D:2','2024-08-10'),
('Ceren','Polat','Female','1999-06-30','ankara337@mail.com','05770000337','Ankara','Yenimahalle','Bahariye Cd. No:96 D:13','2025-07-07'),
('Kubilay','Kaplan','Male','1981-11-07','ankara338@mail.com','05780000338','Ankara','Keçiören','Ortaköy Cd. No:35 D:12','2023-08-31'),
('Büşra','Sezer','Female','1982-08-19','ankara339@mail.com','05790000339','Ankara','Yenimahalle','Menekşe Sk. No:1 D:1','2024-09-03'),
('Okan','Sezer','Male','1984-01-10','ankara340@mail.com','05800000340','Ankara','Altındağ','Menekşe Sk. No:64 D:15','2024-12-09'),
('Seda','Çetin','Female','1973-06-16','ankara341@mail.com','05810000341','Ankara','Keçiören','Cumhuriyet Cd. No:170 D:14','2023-02-02'),
('Kerem','Kurt','Male','1968-01-08','ankara342@mail.com','05820000342','Ankara','Keçiören','Abide-i Hürriyet Cd. No:9 D:15','2023-04-10'),
('Derya','Demir','Female','1983-01-17','ankara343@mail.com','05830000343','Ankara','Gölbaşı','Menekşe Sk. No:139 D:7','2023-04-26'),
('Murat','Köse','Male','1977-12-23','ankara344@mail.com','05840000344','Ankara','Mamak','Doğan Araslı Blv. No:82 D:19','2024-10-18'),
('Derya','Aksoy','Female','2004-04-22','ankara345@mail.com','05850000345','Ankara','Yenimahalle','Teşvikiye Cd. No:57 D:14','2024-09-07'),
('Serkan','Şahin','Male','1989-12-22','ankara346@mail.com','05860000346','Ankara','Yenimahalle','Bahariye Cd. No:143 D:16','2023-04-07'),
('Tuğçe','Kaplan','Female','2000-04-01','ankara347@mail.com','05870000347','Ankara','Sincan','Bahariye Cd. No:105 D:5','2024-09-06'),
('Yusuf','Polat','Male','1998-11-04','ankara348@mail.com','05880000348','Ankara','Gölbaşı','Menekşe Sk. No:58 D:10','2023-10-23'),
('Cansu','Güneş','Female','1967-08-03','ankara349@mail.com','05890000349','Ankara','Altındağ','Bahariye Cd. No:143 D:17','2023-10-02'),
('Yusuf','Taş','Male','1976-06-09','ankara350@mail.com','05900000350','Ankara','Mamak','Sahil Yolu No:166 D:3','2025-07-10'),
('Şeyma','Özdemir','Female','1969-02-23','ankara351@mail.com','05910000351','Ankara','Mamak','Cumhuriyet Cd. No:69 D:13','2023-03-22'),
('Kubilay','Çelik','Male','1973-06-10','ankara352@mail.com','05920000352','Ankara','Mamak','Rıhtım Cd. No:54 D:11','2024-09-12'),
('Eylül','Yılmaz','Female','1974-07-03','ankara353@mail.com','05930000353','Ankara','Mamak','Gazi Cd. No:192 D:16','2024-05-11'),
('Halil','Uçar','Male','1996-07-27','ankara354@mail.com','05940000354','Ankara','Mamak','Halaskargazi Cd. No:62 D:18','2024-10-20'),
('Deniz','Şimşek','Female','1982-01-28','ankara355@mail.com','05950000355','Ankara','Gölbaşı','Ortaköy Cd. No:167 D:12','2024-09-23'),
('Serkan','Özdemir','Male','1988-01-02','ankara356@mail.com','05960000356','Ankara','Gölbaşı','Moda Cd. No:26 D:16','2024-10-17'),
('Eylül','Kurt','Female','1981-08-18','ankara357@mail.com','05970000357','Ankara','Sincan','Bahariye Cd. No:12 D:19','2024-03-29'),
('Eren','Yıldız','Male','1965-09-23','ankara358@mail.com','05980000358','Ankara','Etimesgut','Ortaköy Cd. No:150 D:19','2025-05-05'),
('Melis','Yıldız','Female','1973-10-20','ankara359@mail.com','05990000359','Ankara','Sincan','Menekşe Sk. No:98 D:19','2024-05-18'),
('Onur','Dinç','Male','1994-05-14','ankara360@mail.com','05100000360','Ankara','Sincan','Papatya Sk. No:196 D:16','2025-10-01'),
('Naz','Doğan','Female','1997-11-14','ankara361@mail.com','05110000361','Ankara','Sincan','Fatih Sk. No:36 D:18','2025-09-27'),
('Emre','Sezer','Male','1993-10-16','ankara362@mail.com','05120000362','Ankara','Çankaya','Teşvikiye Cd. No:9 D:3','2023-04-10'),
('Deniz','Yılmaz','Female','1983-07-02','ankara363@mail.com','05130000363','Ankara','Yenimahalle','Menekşe Sk. No:18 D:5','2023-01-19'),
('Can','Köse','Male','1985-06-16','ankara364@mail.com','05140000364','Ankara','Sincan','Cumhuriyet Cd. No:159 D:20','2025-09-16'),
('Selin','Bulut','Female','1965-09-15','ankara365@mail.com','05150000365','Ankara','Çankaya','Ortaköy Cd. No:142 D:14','2023-01-25'),
('Mehmet','Erdoğan','Male','1997-05-25','ankara366@mail.com','05160000366','Ankara','Etimesgut','Ortaköy Cd. No:74 D:1','2025-10-25'),
('Rabia','Sarı','Female','2001-03-01','ankara367@mail.com','05170000367','Ankara','Yenimahalle','Gazi Cd. No:25 D:17','2023-11-01'),
('Kerem','Karaca','Male','1992-10-20','ankara368@mail.com','05180000368','Ankara','Etimesgut','Mimar Sinan Cd. No:69 D:13','2023-06-11'),
('Tuğçe','Aslan','Female','1985-08-04','ankara369@mail.com','05190000369','Ankara','Mamak','Menekşe Sk. No:77 D:3','2023-03-06'),
('Ali','Aslan','Male','1982-01-05','ankara370@mail.com','05200000370','Ankara','Altındağ','Ortaköy Cd. No:122 D:2','2023-01-20'),
('Sıla','Doğan','Female','1968-09-16','ankara371@mail.com','05210000371','Ankara','Gölbaşı','Bahariye Cd. No:166 D:11','2023-07-15'),
('Volkan','Erdoğan','Male','1966-11-29','ankara372@mail.com','05220000372','Ankara','Mamak','Lale Sk. No:178 D:19','2025-08-31'),
('Ece','Demir','Female','1968-05-03','ankara373@mail.com','05230000373','Ankara','Etimesgut','Ortaköy Cd. No:145 D:2','2024-01-03'),
('Cem','Kılıç','Male','1965-09-14','ankara374@mail.com','05240000374','Ankara','Mamak','Doğan Araslı Blv. No:37 D:13','2023-06-07'),
('Melis','Doğan','Female','1990-04-19','ankara375@mail.com','05250000375','Ankara','Mamak','Doğan Araslı Blv. No:100 D:18','2024-11-10'),
('Yusuf','Öztürk','Male','2000-06-17','ankara376@mail.com','05260000376','Ankara','Keçiören','Teşvikiye Cd. No:191 D:12','2023-04-20'),
('Merve','Sarı','Female','1975-06-01','ankara377@mail.com','05270000377','Ankara','Keçiören','Sahil Yolu No:155 D:20','2025-03-23'),
('Barış','Kılıç','Male','1966-05-01','ankara378@mail.com','05280000378','Ankara','Etimesgut','Moda Cd. No:126 D:8','2024-12-29'),
('Gül','Kaplan','Female','1984-05-16','ankara379@mail.com','05290000379','Ankara','Yenimahalle','Doğan Araslı Blv. No:170 D:13','2023-06-25'),
('Barış','Ateş','Male','1978-04-02','ankara380@mail.com','05300000380','Ankara','Mamak','İnönü Cd. No:22 D:9','2023-11-12'),
('Esra','Yıldız','Female','1998-03-07','ankara381@mail.com','05310000381','Ankara','Altındağ','Sahil Yolu No:93 D:4','2023-07-07'),
('Mehmet','Aksoy','Male','1984-12-13','ankara382@mail.com','05320000382','Ankara','Sincan','Papatya Sk. No:27 D:5','2023-06-28'),
('Büşra','Sarı','Female','1985-02-18','ankara383@mail.com','05330000383','Ankara','Altındağ','Gazi Cd. No:7 D:3','2024-12-25'),
('Uğur','Aydın','Male','1991-10-12','ankara384@mail.com','05340000384','Ankara','Sincan','Halaskargazi Cd. No:4 D:10','2025-04-27'),
('Esra','Aydın','Female','1997-07-07','ankara385@mail.com','05350000385','Ankara','Mamak','Doğan Araslı Blv. No:134 D:6','2025-02-18'),
('Emre','Öztürk','Male','1977-01-23','ankara386@mail.com','05360000386','Ankara','Etimesgut','Papatya Sk. No:127 D:5','2023-05-10'),
('Büşra','Sarı','Female','1977-05-19','ankara387@mail.com','05370000387','Ankara','Altındağ','Şehitler Cd. No:124 D:3','2025-01-09'),
('Serkan','Taş','Male','1997-05-04','ankara388@mail.com','05380000388','Ankara','Gölbaşı','Abide-i Hürriyet Cd. No:158 D:7','2025-07-26'),
('Merve','Öztürk','Female','1978-09-01','ankara389@mail.com','05390000389','Ankara','Çankaya','Halaskargazi Cd. No:86 D:20','2025-02-17'),
('Berk','Eren','Male','1984-09-30','ankara390@mail.com','05400000390','Ankara','Sincan','Bahariye Cd. No:167 D:20','2023-10-06'),
('Melis','Kılıç','Female','1992-01-23','ankara391@mail.com','05410000391','Ankara','Mamak','Rıhtım Cd. No:81 D:6','2025-03-26'),
('Hakan','Şimşek','Male','1997-12-19','ankara392@mail.com','05420000392','Ankara','Gölbaşı','Doğan Araslı Blv. No:63 D:11','2025-02-09'),
('Ece','Aslan','Female','1981-05-17','ankara393@mail.com','05430000393','Ankara','Keçiören','Doğan Araslı Blv. No:52 D:19','2024-01-04'),
('İsmail','Dinç','Male','1966-03-17','ankara394@mail.com','05440000394','Ankara','Gölbaşı','Lale Sk. No:113 D:10','2023-05-22'),
('Rabia','Yıldırım','Female','1995-03-11','ankara395@mail.com','05450000395','Ankara','Gölbaşı','Barbaros Blv. No:163 D:10','2024-05-10'),
('Serkan','Yıldız','Male','1997-01-31','ankara396@mail.com','05460000396','Ankara','Altındağ','Halaskargazi Cd. No:19 D:15','2025-09-08'),
('Aslı','Aslan','Female','1988-12-21','ankara397@mail.com','05470000397','Ankara','Altındağ','Ortaköy Cd. No:10 D:12','2023-06-24'),
('Mustafa','Taş','Male','1994-07-02','ankara398@mail.com','05480000398','Ankara','Sincan','Fatih Sk. No:166 D:20','2023-04-01'),
('Aslı','Aslan','Female','1998-10-06','ankara399@mail.com','05490000399','Ankara','Sincan','Bahariye Cd. No:28 D:1','2023-07-21'),
('Serkan','Güler','Male','1987-11-28','ankara400@mail.com','05500000400','Ankara','Mamak','Moda Cd. No:96 D:13','2025-08-06'),
('Deniz','Karataş','Female','1995-12-22','izmir401@mail.com','05510000401','İzmir','Karşıyaka','Mimar Sinan Cd. No:7 D:16','2023-08-03'),
('Burak','Yıldırım','Male','1968-11-07','izmir402@mail.com','05520000402','İzmir','Bornova','Barbaros Blv. No:90 D:10','2024-12-03'),
('Naz','Kurt','Female','1988-05-17','izmir403@mail.com','05530000403','İzmir','Çiğli','Mimar Sinan Cd. No:122 D:4','2025-06-16'),
('Eren','Kara','Male','1979-04-23','izmir404@mail.com','05540000404','İzmir','Bornova','Şehitler Cd. No:12 D:4','2023-02-16'),
('Şeyma','Eren','Female','1994-01-25','izmir405@mail.com','05550000405','İzmir','Bornova','Fatih Sk. No:190 D:8','2025-11-22'),
('Emre','Dinç','Male','1972-03-08','izmir406@mail.com','05560000406','İzmir','Gaziemir','Ortaköy Cd. No:110 D:15','2024-04-19'),
('Cansu','Aslan','Female','1993-04-01','izmir407@mail.com','05570000407','İzmir','Karşıyaka','Fatih Sk. No:164 D:14','2025-03-21'),
('Mehmet','Ateş','Male','2004-08-12','izmir408@mail.com','05580000408','İzmir','Buca','Moda Cd. No:152 D:14','2025-03-07'),
('Ayşe','Kurt','Female','1974-03-26','izmir409@mail.com','05590000409','İzmir','Balçova','İnönü Cd. No:148 D:4','2024-01-18'),
('Ömer','Kılıç','Male','1973-11-03','izmir410@mail.com','05600000410','İzmir','Çiğli','Gazi Cd. No:68 D:16','2025-12-16'),
('Hande','Kılıç','Female','1991-10-12','izmir411@mail.com','05610000411','İzmir','Bayraklı','Abide-i Hürriyet Cd. No:101 D:19','2023-08-22'),
('Ömer','Yalçın','Male','2002-12-05','izmir412@mail.com','05620000412','İzmir','Çiğli','Abide-i Hürriyet Cd. No:45 D:10','2023-06-23'),
('Selin','Öztürk','Female','1979-01-19','izmir413@mail.com','05630000413','İzmir','Bornova','Menekşe Sk. No:79 D:4','2024-01-10'),
('Ömer','Yıldız','Male','1987-12-01','izmir414@mail.com','05640000414','İzmir','Bayraklı','Bahariye Cd. No:153 D:5','2025-02-24'),
('Ceren','Polat','Female','1986-10-31','izmir415@mail.com','05650000415','İzmir','Karşıyaka','Ortaköy Cd. No:43 D:16','2024-08-14'),
('Murat','Polat','Male','1979-02-11','izmir416@mail.com','05660000416','İzmir','Çiğli','Abide-i Hürriyet Cd. No:14 D:12','2023-01-20'),
('Beyza','Öztürk','Female','1973-10-02','izmir417@mail.com','05670000417','İzmir','Bayraklı','Ortaköy Cd. No:130 D:16','2025-04-17'),
('İsmail','Bulut','Male','1983-08-24','izmir418@mail.com','05680000418','İzmir','Çiğli','Rıhtım Cd. No:43 D:3','2023-03-05'),
('Cansu','Güler','Female','1978-02-07','izmir419@mail.com','05690000419','İzmir','Konak','Papatya Sk. No:58 D:18','2024-08-14'),
('Emre','Güneş','Male','1990-05-17','izmir420@mail.com','05700000420','İzmir','Çiğli','Ortaköy Cd. No:131 D:4','2023-08-22'),
('Ece','Sezer','Female','2001-12-06','izmir421@mail.com','05710000421','İzmir','Gaziemir','Ortaköy Cd. No:194 D:2','2025-06-22'),
('Uğur','Kurt','Male','1984-01-27','izmir422@mail.com','05720000422','İzmir','Bornova','Menekşe Sk. No:77 D:2','2025-07-10'),
('Ece','Yalçın','Female','2003-09-05','izmir423@mail.com','05730000423','İzmir','Bornova','Moda Cd. No:31 D:8','2024-03-05'),
('Berk','Karataş','Male','1995-11-30','izmir424@mail.com','05740000424','İzmir','Gaziemir','Abide-i Hürriyet Cd. No:162 D:14','2023-12-06'),
('Yasemin','Öztürk','Female','2000-03-16','izmir425@mail.com','05750000425','İzmir','Buca','Lale Sk. No:16 D:19','2024-12-19'),
('Uğur','Çetin','Male','1991-10-10','izmir426@mail.com','05760000426','İzmir','Karşıyaka','Sahil Yolu No:181 D:10','2024-08-15'),
('Aslı','Çetin','Female','2003-06-28','izmir427@mail.com','05770000427','İzmir','Bornova','Barbaros Blv. No:193 D:14','2023-05-02'),
('Serkan','Öztürk','Male','1996-06-19','izmir428@mail.com','05780000428','İzmir','Karşıyaka','Menekşe Sk. No:38 D:11','2024-05-21'),
('Deniz','Aslan','Female','1986-12-16','izmir429@mail.com','05790000429','İzmir','Karşıyaka','Doğan Araslı Blv. No:162 D:9','2025-04-28'),
('Yusuf','Kara','Male','1968-05-22','izmir430@mail.com','05800000430','İzmir','Bornova','Halaskargazi Cd. No:132 D:9','2025-01-25'),
('Naz','Bulut','Female','1979-09-07','izmir431@mail.com','05810000431','İzmir','Konak','İnönü Cd. No:188 D:15','2025-01-03'),
('Kubilay','Çelik','Male','2000-09-10','izmir432@mail.com','05820000432','İzmir','Bayraklı','Lale Sk. No:110 D:7','2025-10-10'),
('Ece','Kılıç','Female','2002-02-27','izmir433@mail.com','05830000433','İzmir','Balçova','Sahil Yolu No:141 D:19','2023-09-25'),
('Gökhan','Bulut','Male','2000-05-12','izmir434@mail.com','05840000434','İzmir','Gaziemir','Cumhuriyet Cd. No:12 D:4','2025-07-30'),
('Ayşe','Arslan','Female','2003-06-22','izmir435@mail.com','05850000435','İzmir','Karşıyaka','Moda Cd. No:117 D:1','2025-05-26'),
('Can','Öztürk','Male','2004-07-28','izmir436@mail.com','05860000436','İzmir','Balçova','Fatih Sk. No:71 D:3','2025-01-08'),
('Ece','Aydın','Female','1981-09-06','izmir437@mail.com','05870000437','İzmir','Karşıyaka','Cumhuriyet Cd. No:102 D:10','2024-04-24'),
('Kaan','Aydın','Male','1996-07-26','izmir438@mail.com','05880000438','İzmir','Bornova','Atatürk Cd. No:55 D:16','2023-06-09'),
('Seda','Karataş','Female','1975-02-23','izmir439@mail.com','05890000439','İzmir','Çiğli','Atatürk Cd. No:3 D:11','2023-09-04'),
('Kubilay','Sarı','Male','1996-02-19','izmir440@mail.com','05900000440','İzmir','Karşıyaka','Rıhtım Cd. No:19 D:8','2025-02-23'),
('Zeynep','Koç','Female','1969-08-18','izmir441@mail.com','05910000441','İzmir','Gaziemir','Mimar Sinan Cd. No:77 D:5','2025-02-22'),
('Barış','Öztürk','Male','1993-10-12','izmir442@mail.com','05920000442','İzmir','Karşıyaka','İnönü Cd. No:136 D:19','2023-01-18'),
('Yasemin','Doğan','Female','1984-09-28','izmir443@mail.com','05930000443','İzmir','Gaziemir','Lale Sk. No:161 D:5','2025-04-23'),
('Tolga','Kara','Male','2003-07-30','izmir444@mail.com','05940000444','İzmir','Buca','İnönü Cd. No:26 D:5','2023-09-10'),
('Aslı','Kaplan','Female','1980-10-08','izmir445@mail.com','05950000445','İzmir','Bayraklı','Sahil Yolu No:36 D:8','2024-07-21'),
('Sercan','Aydın','Male','1976-02-18','izmir446@mail.com','05960000446','İzmir','Balçova','Atatürk Cd. No:169 D:10','2024-02-25'),
('Hülya','Uçar','Female','1987-11-10','izmir447@mail.com','05970000447','İzmir','Buca','Halaskargazi Cd. No:76 D:2','2024-05-05'),
('Onur','Kaplan','Male','1970-01-22','izmir448@mail.com','05980000448','İzmir','Buca','Rıhtım Cd. No:164 D:20','2023-05-26'),
('Hülya','Yılmaz','Female','1981-03-14','izmir449@mail.com','05990000449','İzmir','Gaziemir','Barbaros Blv. No:100 D:19','2025-05-11'),
('Ömer','Sezer','Male','1995-08-21','izmir450@mail.com','05100000450','İzmir','Karşıyaka','Rıhtım Cd. No:198 D:3','2023-02-04'),
('Aslı','Çelik','Female','1965-08-14','izmir451@mail.com','05110000451','İzmir','Balçova','Lale Sk. No:11 D:2','2025-03-26'),
('Furkan','Şimşek','Male','1993-03-13','izmir452@mail.com','05120000452','İzmir','Bayraklı','Bahariye Cd. No:180 D:13','2023-06-18'),
('Hande','Sezer','Female','1989-02-12','izmir453@mail.com','05130000453','İzmir','Karşıyaka','Papatya Sk. No:22 D:10','2023-06-11'),
('Furkan','Kurt','Male','2001-04-01','izmir454@mail.com','05140000454','İzmir','Karşıyaka','Ortaköy Cd. No:84 D:13','2023-05-16'),
('Melis','Sarı','Female','1997-09-29','izmir455@mail.com','05150000455','İzmir','Buca','Cumhuriyet Cd. No:63 D:3','2025-06-08'),
('Mustafa','Güneş','Male','1992-06-19','izmir456@mail.com','05160000456','İzmir','Konak','Şehitler Cd. No:171 D:6','2023-09-02'),
('Ayşe','Öztürk','Female','1996-06-20','izmir457@mail.com','05170000457','İzmir','Konak','Fatih Sk. No:128 D:12','2025-12-07'),
('Furkan','Ünal','Male','1972-06-28','izmir458@mail.com','05180000458','İzmir','Gaziemir','Barbaros Blv. No:192 D:9','2023-08-30'),
('Deniz','Kaya','Female','1980-01-11','izmir459@mail.com','05190000459','İzmir','Bayraklı','Papatya Sk. No:135 D:3','2024-06-22'),
('Halil','Özkan','Male','1993-02-24','izmir460@mail.com','05200000460','İzmir','Bornova','Rıhtım Cd. No:117 D:17','2025-01-07'),
('Elif','Bulut','Female','2003-07-20','izmir461@mail.com','05210000461','İzmir','Karşıyaka','Mimar Sinan Cd. No:41 D:9','2023-07-30'),
('Volkan','Özkan','Male','1995-03-29','izmir462@mail.com','05220000462','İzmir','Bornova','Menekşe Sk. No:190 D:17','2023-01-06'),
('Elif','Yılmaz','Female','1975-12-21','izmir463@mail.com','05230000463','İzmir','Konak','Rıhtım Cd. No:94 D:13','2023-11-04'),
('Emre','Demir','Male','1989-10-20','izmir464@mail.com','05240000464','İzmir','Bayraklı','Menekşe Sk. No:83 D:8','2025-05-02'),
('Eylül','Kılıç','Female','1977-03-03','izmir465@mail.com','05250000465','İzmir','Bornova','Doğan Araslı Blv. No:96 D:4','2025-10-25'),
('İsmail','Şahin','Male','1973-01-17','izmir466@mail.com','05260000466','İzmir','Buca','Teşvikiye Cd. No:12 D:13','2023-05-22'),
('Nehir','Güneş','Female','2003-11-07','izmir467@mail.com','05270000467','İzmir','Balçova','Şehitler Cd. No:84 D:3','2025-07-24'),
('Mehmet','Özdemir','Male','1974-01-01','izmir468@mail.com','05280000468','İzmir','Balçova','Doğan Araslı Blv. No:78 D:20','2024-05-11'),
('Naz','Özdemir','Female','1991-07-18','izmir469@mail.com','05290000469','İzmir','Çiğli','Lale Sk. No:188 D:18','2024-05-17'),
('Murat','Yılmaz','Male','1983-05-25','izmir470@mail.com','05300000470','İzmir','Konak','Menekşe Sk. No:139 D:12','2023-01-20'),
('Gamze','Yılmaz','Female','1999-01-17','izmir471@mail.com','05310000471','İzmir','Bayraklı','Şehitler Cd. No:27 D:7','2025-12-21'),
('Kerem','Yıldırım','Male','1987-01-27','izmir472@mail.com','05320000472','İzmir','Konak','Barbaros Blv. No:183 D:9','2023-07-10'),
('Elif','Güler','Female','2005-04-02','izmir473@mail.com','05330000473','İzmir','Bayraklı','Mimar Sinan Cd. No:118 D:3','2023-07-15'),
('Furkan','Öztürk','Male','1993-08-02','izmir474@mail.com','05340000474','İzmir','Bayraklı','İnönü Cd. No:152 D:19','2023-05-08'),
('Ceren','Öztürk','Female','1975-08-16','izmir475@mail.com','05350000475','İzmir','Balçova','Papatya Sk. No:81 D:13','2024-10-30'),
('Hakan','Kara','Male','1977-03-14','izmir476@mail.com','05360000476','İzmir','Buca','İnönü Cd. No:52 D:5','2023-08-12'),
('Seda','Koç','Female','1972-05-17','izmir477@mail.com','05370000477','İzmir','Çiğli','Moda Cd. No:81 D:14','2023-09-05'),
('Uğur','Yalçın','Male','1999-07-23','izmir478@mail.com','05380000478','İzmir','Buca','Moda Cd. No:79 D:15','2024-06-26'),
('Şeyma','Arslan','Female','1969-01-21','izmir479@mail.com','05390000479','İzmir','Karşıyaka','Şehitler Cd. No:181 D:20','2023-03-24'),
('Can','Kılıç','Male','1971-08-28','izmir480@mail.com','05400000480','İzmir','Bornova','Menekşe Sk. No:92 D:13','2025-11-17'),
('Elif','Aksoy','Female','1976-09-02','izmir481@mail.com','05410000481','İzmir','Karşıyaka','Atatürk Cd. No:104 D:15','2024-05-26'),
('Mustafa','Güneş','Male','1969-07-28','izmir482@mail.com','05420000482','İzmir','Karşıyaka','Gazi Cd. No:4 D:2','2024-03-31'),
('Seda','Karaca','Female','2001-12-13','izmir483@mail.com','05430000483','İzmir','Bayraklı','Mimar Sinan Cd. No:176 D:3','2024-06-14'),
('Cem','Çelik','Male','1965-12-24','izmir484@mail.com','05440000484','İzmir','Bornova','Lale Sk. No:166 D:15','2023-09-21'),
('Zeynep','Eren','Female','1970-07-01','izmir485@mail.com','05450000485','İzmir','Konak','Moda Cd. No:13 D:6','2025-06-06'),
('Doğukan','Aslan','Male','1987-04-04','izmir486@mail.com','05460000486','İzmir','Konak','Halaskargazi Cd. No:175 D:14','2023-12-20'),
('Tuğçe','Kurt','Female','2005-09-29','izmir487@mail.com','05470000487','İzmir','Karşıyaka','Papatya Sk. No:72 D:15','2023-11-01'),
('Ahmet','Ateş','Male','1992-10-10','izmir488@mail.com','05480000488','İzmir','Buca','Şehitler Cd. No:128 D:14','2025-09-08'),
('Elif','Aydın','Female','1977-07-20','izmir489@mail.com','05490000489','İzmir','Bayraklı','Barbaros Blv. No:108 D:7','2025-12-12'),
('Kerem','Sezer','Male','2000-08-27','izmir490@mail.com','05500000490','İzmir','Konak','Halaskargazi Cd. No:183 D:12','2025-09-09'),
('Gül','Bulut','Female','1980-06-07','izmir491@mail.com','05510000491','İzmir','Gaziemir','Halaskargazi Cd. No:70 D:6','2023-02-23'),
('Hakan','Uçar','Male','1974-10-29','izmir492@mail.com','05520000492','İzmir','Konak','Papatya Sk. No:15 D:16','2025-12-20'),
('Tuğçe','Karataş','Female','1975-06-11','izmir493@mail.com','05530000493','İzmir','Karşıyaka','Gazi Cd. No:64 D:8','2024-06-29'),
('Uğur','Şahin','Male','1999-04-11','izmir494@mail.com','05540000494','İzmir','Buca','Doğan Araslı Blv. No:100 D:12','2023-12-22'),
('Büşra','Taş','Female','1991-07-31','izmir495@mail.com','05550000495','İzmir','Gaziemir','Mimar Sinan Cd. No:152 D:1','2024-12-21'),
('Gökhan','Özkan','Male','1971-05-18','izmir496@mail.com','05560000496','İzmir','Buca','Rıhtım Cd. No:139 D:10','2023-12-26'),
('Beyza','Demir','Female','1969-01-18','izmir497@mail.com','05570000497','İzmir','Konak','Menekşe Sk. No:155 D:8','2023-02-10'),
('Furkan','Avcı','Male','1965-01-12','izmir498@mail.com','05580000498','İzmir','Gaziemir','Abide-i Hürriyet Cd. No:52 D:5','2024-11-28'),
('Sıla','Polat','Female','2000-12-29','izmir499@mail.com','05590000499','İzmir','Gaziemir','Cumhuriyet Cd. No:6 D:5','2023-10-18'),
('Barış','Arslan','Male','2002-12-21','izmir500@mail.com','05600000500','İzmir','Gaziemir','İnönü Cd. No:96 D:13','2023-07-26');



DELIMITER $$
CREATE TRIGGER ai_sale_item_stock_out
AFTER INSERT ON sale_item
FOR EACH ROW
BEGIN
    UPDATE supplies
    SET quantity = quantity - NEW.quantity
    WHERE branch_id = NEW.branch_id
      AND product_id = NEW.product_id
    ORDER BY expiry_date
    LIMIT 1;
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER ad_sale_item_stock_restore
AFTER DELETE ON sale_item
FOR EACH ROW
BEGIN
    UPDATE supplies
    SET quantity = quantity + OLD.quantity
    WHERE branch_id = OLD.branch_id
      AND product_id = OLD.product_id
    ORDER BY expiry_date
    LIMIT 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER bi_sale_item_set_discount_by_expiry
BEFORE INSERT ON sale_item
FOR EACH ROW
BEGIN
    DECLARE en_yakin_skt DATE;
    DECLARE gun_farki INT;
    SELECT MIN(expiry_date)
    INTO en_yakin_skt
    FROM supplies
    WHERE branch_id = NEW.branch_id
      AND product_id = NEW.product_id;
    SET gun_farki = DATEDIFF(en_yakin_skt, CURDATE());
    IF gun_farki <= 3 THEN
        SET NEW.discount_rate = 20;
    ELSEIF gun_farki <= 7 THEN
        SET NEW.discount_rate = 10;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER ai_sale_item_update_sale_totals
AFTER INSERT ON sale_item
FOR EACH ROW
BEGIN
    DECLARE v_subtotal DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    SELECT
        IFNULL(SUM(quantity * unit_price), 0)
    INTO v_subtotal
    FROM sale_item
    WHERE sale_id = NEW.sale_id;
    SET v_tax = v_subtotal * 0.18;
    UPDATE sale
    SET
        subtotal = v_subtotal,
        tax_amount = v_tax,
        total_amount = v_subtotal + v_tax
    WHERE sale_id = NEW.sale_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER bi_sale_item_stock_and_expiry_check
BEFORE INSERT ON sale_item
FOR EACH ROW
BEGIN
    DECLARE v_branch_id INT;
    DECLARE v_available_stock DECIMAL(12,3);
    -- Satışın yapıldığı şube
    SELECT branch_id
    INTO v_branch_id
    FROM sale
    WHERE sale_id = NEW.sale_id;
    -- Geçerli (SKT geçmemiş) toplam stok
    SELECT COALESCE(SUM(s.quantity), 0)
    INTO v_available_stock
    FROM supplies s
    WHERE s.branch_id = v_branch_id
      AND s.product_id = NEW.product_id
      AND s.expiry_date >= CURDATE();
    -- Stok yoksa
    IF v_available_stock = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bu ürün için geçerli (SKT geçmiş olmayan) stok yok';
    END IF;
    -- Yetersiz stok
    IF NEW.quantity > v_available_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Yetersiz stok: Satılan miktar mevcut stoktan fazla';
    END IF;
END$$
DELIMITER ;

-- 18 yaş konrtol triggeri
DELIMITER $$
CREATE TRIGGER bi_sale_item_age_check
BEFORE INSERT ON sale_item
FOR EACH ROW
BEGIN
    DECLARE v_min_age INT DEFAULT 0;
    DECLARE v_customer_id INT;
    DECLARE v_customer_age INT;
    -- Ürünün yaş kısıtı
    SELECT COALESCE(min_age, 0)
    INTO v_min_age
    FROM product
    WHERE product_id = NEW.product_id;
    -- SADECE 18+ ürünlerde kontrol yap
    IF v_min_age >= 18 THEN
        -- Satıştaki müşteri
        SELECT customer_id
        INTO v_customer_id
        FROM sale
        WHERE sale_id = NEW.sale_id;
        IF v_customer_id IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '18+ ürünlerde müşteri bilgisi zorunludur';
        END IF;
        -- Müşteri yaşı
        SELECT TIMESTAMPDIFF(YEAR, birth_date, CURDATE())
        INTO v_customer_age
        FROM customer
        WHERE customer_id = v_customer_id;
        IF v_customer_age < 18 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '18 yaşından küçük müşterilere sigara ve alkol satışı yapılamaz';
        END IF;
    END IF;
END$$
DELIMITER ;



-- sorgular
-- ilişkileri kanitlamak için foreign keyler
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE()
  AND REFERENCED_TABLE_NAME IS NOT NULL;
  -- şubelere göre stok listesi
SELECT
    b.branch_name,
    p.brand,
    sp.quantity,
    sp.expiry_date
FROM supplies sp
JOIN branch b ON b.branch_id = sp.branch_id
JOIN product p ON p.product_id = sp.product_id
ORDER BY b.branch_name, p.brand;
-- bir şubede hangi ürünler var
SELECT
    p.product_id,
    p.brand,
    SUM(sp.quantity) AS total_stock
FROM supplies sp
JOIN product p ON p.product_id = sp.product_id
WHERE sp.branch_id = 1
GROUP BY p.product_id, p.brand;
-- son kullanma tarihi geçmiş ürünler
SELECT
    p.brand,
    sp.expiry_date,
    sp.quantity
FROM supplies sp
JOIN product p ON p.product_id = sp.product_id
WHERE sp.expiry_date < CURDATE();
-- son kullanma tarihine 7 ve daha az kalan ürünler
SELECT
    p.brand,
    MIN(sp.expiry_date) AS nearest_expiry,
    DATEDIFF(MIN(sp.expiry_date), CURDATE()) AS days_left
FROM supplies sp
JOIN product p ON p.product_id = sp.product_id
GROUP BY p.brand
HAVING days_left <= 7;
-- indirim uygulanan satiş detaylari(şube ve ürün bazli)
SELECT
    s.sale_id,
    s.sale_datetime,
    b.branch_name,
    p.brand,
    si.quantity,
    si.unit_price,
    si.discount_rate
FROM sale_item si
JOIN sale s ON s.sale_id = si.sale_id
JOIN product p ON p.product_id = si.product_id
JOIN branch b ON b.branch_id = si.branch_id
WHERE si.discount_rate > 0
ORDER BY s.sale_datetime DESC;
-- hangi üründe ne kadar indirim var
SELECT
    p.brand,
    si.discount_rate,
    COUNT(*) AS sale_count
FROM sale_item si
JOIN product p ON p.product_id = si.product_id
WHERE si.discount_rate > 0
GROUP BY p.brand, si.discount_rate;
-- şubeye göre toplam ciro
SELECT
    b.branch_name,
    SUM(s.total_amount) AS total_revenue
FROM sale s
JOIN branch b ON b.branch_id = s.branch_id
GROUP BY b.branch_name;
-- günlük satiş raporu
SELECT
    DATE(sale_datetime) AS sale_date,
    COUNT(*) AS sale_count,
    SUM(total_amount) AS daily_total
FROM sale
GROUP BY DATE(sale_datetime)
ORDER BY sale_date;
-- en çok satilan ürünlerin markasi
SELECT
    p.brand,
    SUM(si.quantity) AS total_sold
FROM sale_item si
JOIN product p ON p.product_id = si.product_id
GROUP BY p.brand
ORDER BY total_sold DESC;
-- indirim uygulanan ürünler 
SELECT 
    s.sale_id,
    s.sale_datetime,
    b.branch_name,
    p.brand,
    si.quantity,
    si.unit_price,
    si.discount_rate
FROM sale_item si
JOIN sale s ON s.sale_id = si.sale_id
JOIN product p ON p.product_id = si.product_id
JOIN branch b ON b.branch_id = s.branch_id
WHERE si.discount_rate > 0
ORDER BY s.sale_datetime DESC;
-- 18+ ürünü olan satişlar
SELECT 
    s.sale_id,
    p.brand,
    c.first_name,
    c.last_name
FROM sale_item si
JOIN product p ON p.product_id = si.product_id
JOIN sale s ON s.sale_id = si.sale_id
JOIN customer c ON c.customer_id = s.customer_id
WHERE p.min_age >= 18;
-- şube bazli satilan ürün adedi
SELECT 
    b.branch_name,
    SUM(si.quantity) AS total_quantity
FROM sale_item si
JOIN sale s ON s.sale_id = si.sale_id
JOIN branch b ON b.branch_id = s.branch_id
GROUP BY b.branch_name;
-- kategori bazli satişlar
SELECT 
    c.category_name,
    SUM(si.quantity) AS total_quantity
FROM sale_item si
JOIN product p ON p.product_id = si.product_id
JOIN category c ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY total_quantity DESC;
-- stoğu azalan ürünler
SELECT 
    p.brand,
    bps.stock_quantity
FROM branch_product_stock bps
JOIN product p ON p.product_id = bps.product_id
WHERE bps.stock_quantity < 10;
-- Hafta içi ve hafta sonu toplam satış karşılaştırması
SELECT
  CASE
    WHEN DAYOFWEEK(sale_datetime) IN (1,7) THEN 'Hafta Sonu'
    ELSE 'Hafta İçi'
  END AS day_type,
  COUNT(*) AS total_sales_count,
  SUM(total_amount) AS total_revenue
FROM sale
GROUP BY day_type;
-- Yaş aralığına göre müşteri ziyaretleri
SELECT
  CASE
    WHEN age BETWEEN 18 AND 25 THEN '18–25'
    WHEN age BETWEEN 26 AND 35 THEN '26–35'
    WHEN age BETWEEN 36 AND 45 THEN '36–45'
    WHEN age BETWEEN 46 AND 60 THEN '46–60'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS visit_count
FROM (
  SELECT
    s.sale_id,
    TIMESTAMPDIFF(YEAR, c.birth_date, CURDATE()) AS age
  FROM sale s
  JOIN customer c ON c.customer_id = s.customer_id
) t
GROUP BY age_group
ORDER BY visit_count DESC;
-- Gündüz / Akşam / Gece alışveriş analizi
SELECT
  CASE
    WHEN HOUR(sale_datetime) BETWEEN 6 AND 17 THEN 'Gündüz'
    WHEN HOUR(sale_datetime) BETWEEN 18 AND 22 THEN 'Akşam'
    ELSE 'Gece'
  END AS time_period,
  COUNT(*) AS sale_count,
  SUM(total_amount) AS total_revenue
FROM sale
GROUP BY time_period
ORDER BY sale_count DESC;
-- Yaş grubu + saat dilimi alışveriş analizi
SELECT
  age_group,
  time_period,
  COUNT(*) AS sale_count
FROM (
  SELECT
    s.sale_id,
    CASE
      WHEN TIMESTAMPDIFF(YEAR, c.birth_date, CURDATE()) < 30 THEN 'Genç'
      WHEN TIMESTAMPDIFF(YEAR, c.birth_date, CURDATE()) BETWEEN 30 AND 50 THEN 'Orta Yaş'
      ELSE 'Yaşlı'
    END AS age_group,
    CASE
      WHEN HOUR(s.sale_datetime) BETWEEN 6 AND 17 THEN 'Gündüz'
      ELSE 'Akşam/Gece'
    END AS time_period
  FROM sale s
  JOIN customer c ON c.customer_id = s.customer_id
) t
GROUP BY age_group, time_period
ORDER BY age_group, sale_count DESC;
-- Genç müşterilerin (18–29) en çok satın aldığı ürünler
SELECT
  p.brand,
  SUM(si.quantity) AS total_quantity
FROM sale_item si
JOIN sale s ON s.sale_id = si.sale_id
JOIN customer c ON c.customer_id = s.customer_id
JOIN product p ON p.product_id = si.product_id
WHERE TIMESTAMPDIFF(YEAR, c.birth_date, CURDATE()) BETWEEN 18 AND 29
GROUP BY p.brand
ORDER BY total_quantity DESC
LIMIT 10;





















































        
        
    
     