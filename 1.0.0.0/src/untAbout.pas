unit untAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TFrmAbout = class(TForm)
    Image1: TImage;
  private
    { Private declarations }
  public
     class procedure Exibir;
  end;

var
  FrmAbout: TFrmAbout;

implementation

{$R *.dfm}

{ TFrmAbout }

class procedure TFrmAbout.Exibir;
begin
  var Frm := TFrmAbout.Create(nil);
  try
    Frm.ShowModal;
  finally
    FreeAndNil(Frm);
  end;
end;

end.
