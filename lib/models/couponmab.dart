class CouponMABData {
  String? id;
  String? namaDepan;
  String? namaBelakang;
  String? tempatLahir;
  String? tanggalLahir;
  String? jenisKelamin;
  String? noHp;
  String? noLama;
  String? alamat;
  String? provinsi;
  String? kota;
  String? kecamatan;
  String? kelurahan;
  String? kodePos;
  String? custID;
  String? custName;
  String? stampPhoto;
  String? signature;
  String? approvedNumberBy;
  String? approvedNumberOn;
  String? approvedBy;
  String? approvedOn;
  String? jenis;
  String? createdBy;
  String? salesName;
  String? createdOn;

  CouponMABData(
      {this.id,
      this.namaDepan,
      this.namaBelakang,
      this.tempatLahir,
      this.tanggalLahir,
      this.jenisKelamin,
      this.noHp,
      this.noLama,
      this.alamat,
      this.provinsi,
      this.kota,
      this.kecamatan,
      this.kelurahan,
      this.kodePos,
      this.custID,
      this.custName,
      this.stampPhoto,
      this.signature,
      this.approvedNumberBy,
      this.approvedNumberOn,
      this.approvedBy,
      this.approvedOn,
      this.jenis,
      this.createdBy,
      this.salesName,
      this.createdOn});

  CouponMABData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    namaDepan = json['NamaDepan'];
    namaBelakang = json['NamaBelakang'];
    tempatLahir = json['TempatLahir'];
    tanggalLahir = json['TanggalLahir'];
    jenisKelamin = json['JenisKelamin'];
    noHp = json['NoHp'];
    noLama = json['NoLama'];
    alamat = json['Alamat'];
    provinsi = json['Provinsi'];
    kota = json['Kota'];
    kecamatan = json['Kecamatan'];
    kelurahan = json['Kelurahan'];
    kodePos = json['KodePos'];
    custID = json['CustID'];
    custName = json['CustName'];
    stampPhoto = json['StampPhoto'];
    signature = json['Signature'];
    approvedNumberBy = json['ApprovedNumberBy'];
    approvedNumberOn = json['ApprovedNumberOn'];
    approvedBy = json['ApprovedBy'];
    approvedOn = json['ApprovedOn'];
    jenis = json['Jenis'];
    createdBy = json['CreatedBy'];
    salesName = json['SalesName'];
    createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['NamaDepan'] = this.namaDepan;
    data['NamaBelakang'] = this.namaBelakang;
    data['TempatLahir'] = this.tempatLahir;
    data['TanggalLahir'] = this.tanggalLahir;
    data['JenisKelamin'] = this.jenisKelamin;
    data['NoHp'] = this.noHp;
    data['NoLama'] = this.noLama;
    data['Alamat'] = this.alamat;
    data['Provinsi'] = this.provinsi;
    data['Kota'] = this.kota;
    data['Kecamatan'] = this.kecamatan;
    data['Kelurahan'] = this.kelurahan;
    data['KodePos'] = this.kodePos;
    data['CustID'] = this.custID;
    data['CustName'] = this.custName;
    data['StampPhoto'] = this.stampPhoto;
    data['Signature'] = this.signature;
    data['ApprovedNumberBy'] = this.approvedNumberBy;
    data['ApprovedNumberOn'] = this.approvedNumberOn;
    data['ApprovedBy'] = this.approvedBy;
    data['ApprovedOn'] = this.approvedOn;
    data['Jenis'] = this.jenis;
    data['CreatedBy'] = this.createdBy;
    data['SalesName'] = this.salesName;
    data['CreatedOn'] = this.createdOn;
    return data;
  }
}
