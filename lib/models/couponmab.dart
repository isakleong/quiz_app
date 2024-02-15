class CouponMABData {
  String? id;
  String? namaDepan;
  String? namaBelakang;
  String? tempatLahir;
  String? jenisKelamin;
  String? noHp;
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
  String? createdOn;

  CouponMABData(
      {this.id,
      this.namaDepan,
      this.namaBelakang,
      this.tempatLahir,
      this.jenisKelamin,
      this.noHp,
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
      this.createdOn});

  CouponMABData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    namaDepan = json['NamaDepan'];
    namaBelakang = json['NamaBelakang'];
    tempatLahir = json['TempatLahir'];
    jenisKelamin = json['JenisKelamin'];
    noHp = json['NoHp'];
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
    createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['NamaDepan'] = this.namaDepan;
    data['NamaBelakang'] = this.namaBelakang;
    data['TempatLahir'] = this.tempatLahir;
    data['JenisKelamin'] = this.jenisKelamin;
    data['NoHp'] = this.noHp;
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
    data['CreatedOn'] = this.createdOn;
    return data;
  }
}
