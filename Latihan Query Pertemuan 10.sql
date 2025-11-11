-- 1. Tampilkan pelanggan dengan jumlah penjualan 3 paling tinggi dengan bayaran yang mahal
SELECT 
    p.Nama_Pelanggan,
    SUM(d.Jumlah * d.Harga_Satuan) AS Total_Pembayaran
FROM Penjualan pj
JOIN Pelanggan p ON pj.Kode_Pelanggan = p.Kode_Pelanggan
JOIN Detail_Nota d ON pj.Nomor_Nota = d.Nomor_Nota
GROUP BY p.Nama_Pelanggan
ORDER BY Total_Pembayaran DESC
LIMIT 3;

-- 2. Siapa pelanggan yang masih punya hutang?
SELECT 
    p.Nama_Pelanggan,
    SUM(d.Jumlah * d.Harga_Satuan) - pj.DP AS Sisa_Hutang
FROM Penjualan pj
JOIN Pelanggan p ON pj.Kode_Pelanggan = p.Kode_Pelanggan
JOIN Detail_Nota d ON pj.Nomor_Nota = d.Nomor_Nota
GROUP BY p.Nama_Pelanggan, pj.DP
HAVING Sisa_Hutang > 0;

-- 3. Barang apa yang paling banyak terjual bulan ini?
SELECT 
    b.Nama_Barang,
    SUM(d.Jumlah) AS Total_Terjual
FROM Detail_Nota d
JOIN Barang b ON d.Kode_Barang = b.Kode_Barang
JOIN Penjualan pj ON d.Nomor_Nota = pj.Nomor_Nota
WHERE MONTH(pj.Tanggal) = MONTH(CURDATE()) 
  AND YEAR(pj.Tanggal) = YEAR(CURDATE())
GROUP BY b.Nama_Barang
ORDER BY Total_Terjual DESC
LIMIT 1;

-- 4. Siapa saja pelanggan yang harus ditagih?
SELECT 
    p.Nama_Pelanggan,
    pj.Nomor_Nota,
    pj.Jatuh_Tempo,
    (SUM(d.Jumlah * d.Harga_Satuan) - pj.DP) AS Hutang
FROM Penjualan pj
JOIN Pelanggan p ON pj.Kode_Pelanggan = p.Kode_Pelanggan
JOIN Detail_Nota d ON pj.Nomor_Nota = d.Nomor_Nota
WHERE pj.Jatuh_Tempo < CURDATE()
GROUP BY p.Nama_Pelanggan, pj.Nomor_Nota, pj.Jatuh_Tempo, pj.DP
HAVING Hutang > 0;

-- 5. Siapa kasir yang melayani pelanggan paling banyak?
SELECT 
    k.Nama_Kasir,
    COUNT(DISTINCT pj.Kode_Pelanggan) AS Jumlah_Pelanggan
FROM Penjualan pj
JOIN Kasir k ON pj.Kode_Kasir = k.Kode_Kasir
GROUP BY k.Nama_Kasir
ORDER BY Jumlah_Pelanggan DESC
LIMIT 1;

-- 6. Mana barang yang stoknya hampir habis?
SELECT 
    Kode_Barang,
    Nama_Barang,
    Stok
FROM Barang
WHERE Stok <= 3
ORDER BY Stok ASC;
