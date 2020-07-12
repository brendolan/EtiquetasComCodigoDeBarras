unit untEtiquetas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, frxClass, Vcl.ExtCtrls,
  frxPreview, Vcl.StdCtrls, Data.DB, Datasnap.DBClient, frxDBSet, Vcl.Grids,
  Vcl.DBGrids, frxRich, frxCross, frxOLE, frxBarcode, frxChBox, frxGradient,
  frxExportBaseDialog, frxExportPDF, Vcl.ComCtrls, frxBarcod;

type
  TFrmEtiquetas = class(TForm)
    frxReport: TfrxReport;
    pnlOpcoes: TPanel;
    frxPreview: TfrxPreview;
    btnSet: TButton;
    ClientDataSet: TClientDataSet;
    frxDBDataset: TfrxDBDataset;
    DataSource: TDataSource;
    frxPDFExport: TfrxPDFExport;
    btnExpPDF: TButton;
    Button1: TButton;
    PageControl1: TPageControl;
    tsFolha: TTabSheet;
    tsColunas: TTabSheet;
    Label10: TLabel;
    edtFolhaMargemEsquerda: TEdit;
    Label14: TLabel;
    Label11: TLabel;
    edtFolhaMargemTopo: TEdit;
    Label16: TLabel;
    Label13: TLabel;
    edtFolhaMargemInferior: TEdit;
    Label17: TLabel;
    Label15: TLabel;
    edtFolhaMargemDireita: TEdit;
    Label12: TLabel;
    Label1: TLabel;
    edtColunasQuantidade: TEdit;
    Label3: TLabel;
    edtColunasEspacoEntreColunas: TEdit;
    Label2: TLabel;
    edtColunasLargura: TEdit;
    Label9: TLabel;
    edtColunasAltura: TEdit;
    tsEtiqueta: TTabSheet;
    lblTextoLeft: TLabel;
    edtTextoLeft: TEdit;
    Label6: TLabel;
    edtTextoTop: TEdit;
    Label7: TLabel;
    edtTextoWidth: TEdit;
    Label8: TLabel;
    edtTextoHeight: TEdit;
    tsDadosParaImpressao: TTabSheet;
    Label4: TLabel;
    edtDe: TEdit;
    Label5: TLabel;
    edtAte: TEdit;
    cbOrientacao: TComboBox;
    Label18: TLabel;
    cbDuplex: TCheckBox;
    Label19: TLabel;
    cbTamanhoDaFolha: TComboBox;
    cbBarType: TComboBox;
    Label20: TLabel;
    ClientDataSetTexto: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExpPDFClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function GetPaperSize: Integer;
    function GetBarType: TfrxBarcodeType;
  public
    { Public declarations }
  end;

var
  FrmEtiquetas: TFrmEtiquetas;

const
  mmToPixels: Extended = 37.59;
  mmToCm: Extended = 10;

implementation

uses Math, untAbout;

{$R *.dfm}

procedure TFrmEtiquetas.btnExpPDFClick(Sender: TObject);
begin
   frxReport.Export(frxPDFExport);
end;

procedure TFrmEtiquetas.btnSetClick(Sender: TObject);
var
   De, Ate: Extended;

  function GetOrientacao: TPrinterOrientation;
  begin
    if cbOrientacao.ItemIndex = 0 then
      Result := TPrinterOrientation.poPortrait
    else
      Result := TPrinterOrientation.poLandscape;
  end;

  function GetDuplex: TfrxDuplexMode;
  begin
    if not cbDuplex.Checked then
    begin
      Result := TfrxDuplexMode.dmNone
    end
    else
    begin
      if GetOrientacao = TPrinterOrientation.poPortrait then
        Result := TfrxDuplexMode.dmVertical
      else
        Result := TfrxDuplexMode.dmHorizontal;
    end;
  end;

begin
  De := StrToFloatDef(edtDe.Text, 0);
  Ate := StrToFloatDef(edtAte.Text, 0);

  ClientDataSet.EmptyDataSet;

  while not (De > Ate) do
  begin
    ClientDataSet.Insert;
    ClientDataSet.FieldByName('Texto').AsString := De.ToString;
    ClientDataSet.Post;

    De := De + 1;
  end;

  //Configurações da Folha
  (frxReport.FindObject('Page') as TfrxReportPage).LeftMargin   := StrToFloatDef(edtFolhaMargemEsquerda.Text, 0) * mmToCm;
  (frxReport.FindObject('Page') as TfrxReportPage).RightMargin  := StrToFloatDef(edtFolhaMargemDireita.Text, 0)  * mmToCm;
  (frxReport.FindObject('Page') as TfrxReportPage).TopMargin    := StrToFloatDef(edtFolhaMargemTopo.Text, 0)     * mmToCm;
  (frxReport.FindObject('Page') as TfrxReportPage).BottomMargin := StrToFloatDef(edtFolhaMargemInferior.Text, 0) * mmToCm;
  (frxReport.FindObject('Page') as TfrxReportPage).Orientation  := GetOrientacao;
  (frxReport.FindObject('Page') as TfrxReportPage).Duplex       := GetDuplex;
  (frxReport.FindObject('Page') as TfrxReportPage).PaperSize    := GetPaperSize;

  //Colunas
  (frxReport.FindObject('mdEtiquetas') as TFrxMasterData).Columns     := StrToIntDef(edtColunasQuantidade.Text, 0);
  (frxReport.FindObject('mdEtiquetas') as TFrxMasterData).ColumnGap   := StrToFloatDef(edtColunasEspacoEntreColunas.Text, 0) * mmToPixels;
  (frxReport.FindObject('mdEtiquetas') as TFrxMasterData).ColumnWidth := StrToFloatDef(edtColunasLargura.Text, 0)            * mmToPixels;
  (frxReport.FindObject('mdEtiquetas') as TFrxMasterData).Height      := StrToFloatDef(edtColunasAltura.Text, 0)             * mmToPixels;

  //Código de Barras
  (frxReport.FindObject('edtTexto') as TFrxBarCodeView).BarType := GetBarType;
  frxReport.FindObject('edtTexto').Left   := StrToFloatDef(edtTextoLeft.Text, 0)   * mmToPixels;
  frxReport.FindObject('edtTexto').Top    := StrToFloatDef(edtTextoTop.Text, 0)    * mmToPixels;
  frxReport.FindObject('edtTexto').Width  := StrToFloatDef(edtTextoWidth.Text, 0)  * mmToPixels;
  frxReport.FindObject('edtTexto').Height := StrToFloatDef(edtTextoHeight.Text, 0) * mmToPixels;

  frxReport.PrepareReport();
end;

procedure TFrmEtiquetas.Button1Click(Sender: TObject);
begin
  TFrmAbout.Exibir;
end;

procedure TFrmEtiquetas.FormCreate(Sender: TObject);
begin
   frxReport.Preview := frxPreview;
   frxReport.PrepareReport();
end;

procedure TFrmEtiquetas.FormShow(Sender: TObject);
begin
  //Colunas
  edtColunasQuantidade.Text         := (frxReport.FindObject('mdEtiquetas') as TFrxMasterData).Columns.ToString;
  edtColunasEspacoEntreColunas.Text := FloatToStr(RoundTo((frxReport.FindObject('mdEtiquetas') as TFrxMasterData).ColumnGap   / mmToPixels, -2));
  edtColunasLargura.Text            := FloatToStr(RoundTo((frxReport.FindObject('mdEtiquetas') as TFrxMasterData).ColumnWidth / mmToPixels, -2));
  edtColunasAltura.Text             := FloatToStr(RoundTo((frxReport.FindObject('mdEtiquetas') as TFrxMasterData).Height      / mmToPixels, -2));

  //Código de Barras
  edtTextoLeft.Text   := FloatToStr(RoundTo(frxReport.FindObject('edtTexto').Left   / mmToPixels, -2));
  edtTextoTop.Text    := FloatToStr(RoundTo(frxReport.FindObject('edtTexto').Top    / mmToPixels, -2));
  edtTextoWidth.Text  := FloatToStr(RoundTo(frxReport.FindObject('edtTexto').Width  / mmToPixels, -2));
  edtTextoHeight.Text := FloatToStr(RoundTo(frxReport.FindObject('edtTexto').Height / mmToPixels, -2));

  //Configurações da Folha
  edtFolhaMargemEsquerda.Text := FloatToStr((frxReport.FindObject('Page') as TfrxReportPage).LeftMargin / mmToCm);
  edtFolhaMargemDireita.Text  := FloatToStr((frxReport.FindObject('Page') as TfrxReportPage).RightMargin / mmToCm);
  edtFolhaMargemTopo.Text     := FloatToStr((frxReport.FindObject('Page') as TfrxReportPage).TopMargin / mmToCm);
  edtFolhaMargemInferior.Text := FloatToStr((frxReport.FindObject('Page') as TfrxReportPage).BottomMargin / mmToCm);


end;

function TFrmEtiquetas.GetBarType: TfrxBarcodeType;
begin
  case cbBarType.ItemIndex of
     0: Result := bcCode_2_5_interleaved;
     1: Result := bcCode_2_5_industrial;
     2: Result := bcCode_2_5_matrix;
     3: Result := bcCode39;
     4: Result := bcCode39Extended;
     5: Result := bcCode128;
     6: Result := bcCode128A;
     7: Result := bcCode128B;
     8: Result := bcCode93;
     9: Result := bcCode93Extended;
    10: Result := bcCodeMSI;
    11: Result := bcCodePostNet;
    12: Result := bcCodeCodabar;
    13: Result := bcCodeEAN8;
    14: Result := bcCodeEAN13;
    15: Result := bcCodeUPC_A;
    16: Result := bcCodeUPC_E0;
    17: Result := bcCodeUPC_E1;
    18: Result := bcCodeUPC_Supp2;
    19: Result := bcCodeUPC_Supp5;
    20: Result := bcCodeEAN128;
    21: Result := bcCodeEAN128A;
    22: Result := bcCodeEAN128B;
    23: Result := bcCodeUSPSIntelligentMail;
    24: Result := bcPharmacode;
  else
    Result := bcCode128;
  end;
end;

function TFrmEtiquetas.GetPaperSize: Integer;
begin
  case cbTamanhoDaFolha.ItemIndex of
    0: Result := DMPAPER_LETTER;
    1: Result := DMPAPER_LETTERSMALL;
    2: Result := DMPAPER_TABLOID;
    3: Result := DMPAPER_LEDGER;
    4: Result := DMPAPER_LEGAL;
    5: Result := DMPAPER_STATEMENT;
    6: Result := DMPAPER_EXECUTIVE;
    7: Result := DMPAPER_A3;
    8: Result := DMPAPER_A4;
    9: Result := DMPAPER_A4SMALL;
    10: Result := DMPAPER_A5;
    11: Result := DMPAPER_B4;
    12: Result := DMPAPER_B5;
    13: Result := DMPAPER_FOLIO;
    14: Result := DMPAPER_QUARTO;
    15: Result := DMPAPER_10X14;
    16: Result := DMPAPER_11X17;
    17: Result := DMPAPER_NOTE;
    18: Result := DMPAPER_ENV_9;
    19: Result := DMPAPER_ENV_10;
    20: Result := DMPAPER_ENV_11;
    21: Result := DMPAPER_ENV_12;
    22: Result := DMPAPER_ENV_14;
    23: Result := DMPAPER_CSHEET;
    24: Result := DMPAPER_DSHEET;
    25: Result := DMPAPER_ESHEET;
    26: Result := DMPAPER_ENV_DL;
    27: Result := DMPAPER_ENV_C5;
    28: Result := DMPAPER_ENV_C3;
    29: Result := DMPAPER_ENV_C4;
    30: Result := DMPAPER_ENV_C6;
    31: Result := DMPAPER_ENV_C65;
    32: Result := DMPAPER_ENV_B4;
    33: Result := DMPAPER_ENV_B5;
    34: Result := DMPAPER_ENV_B6;
    35: Result := DMPAPER_ENV_ITALY;
    36: Result := DMPAPER_ENV_MONARCH;
    37: Result := DMPAPER_ENV_PERSONAL;
    38: Result := DMPAPER_FANFOLD_US;
    39: Result := DMPAPER_FANFOLD_STD_GERMAN;
    40: Result := DMPAPER_FANFOLD_LGL_GERMAN;
    41: Result := DMPAPER_ISO_B4;
    42: Result := DMPAPER_JAPANESE_POSTCARD;
    43: Result := DMPAPER_9X11;
    44: Result := DMPAPER_10X11;
    45: Result := DMPAPER_15X11;
    46: Result := DMPAPER_ENV_INVITE;
    47: Result := DMPAPER_LETTER_EXTRA;
    48: Result := DMPAPER_LEGAL_EXTRA;
    49: Result := DMPAPER_TABLOID_EXTRA;
    50: Result := DMPAPER_A4_EXTRA;
    51: Result := DMPAPER_LETTER_TRANSVERSE;
    52: Result := DMPAPER_A4_TRANSVERSE;
    53: Result := DMPAPER_LETTER_EXTRA_TRANSVERSE;
    54: Result := DMPAPER_A_PLUS;
    55: Result := DMPAPER_B_PLUS;
    56: Result := DMPAPER_LETTER_PLUS;
    57: Result := DMPAPER_A4_PLUS;
    58: Result := DMPAPER_A5_TRANSVERSE;
    59: Result := DMPAPER_B5_TRANSVERSE;
    60: Result := DMPAPER_A3_EXTRA;
    61: Result := DMPAPER_A5_EXTRA;
    62: Result := DMPAPER_B5_EXTRA;
    63: Result := DMPAPER_A2;
    64: Result := DMPAPER_A3_TRANSVERSE;
    65: Result := DMPAPER_A3_EXTRA_TRANSVERSE;
  else
    Result := DMPAPER_A4;
  end;
end;

end.
