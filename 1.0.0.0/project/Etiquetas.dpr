program Etiquetas;

uses
  midaslib,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  untAbout in '..\src\untAbout.pas' {FrmAbout},
  untEtiquetas in '..\src\untEtiquetas.pas' {FrmEtiquetas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Turquoise Gray');
  Application.Title := 'Impressão de Etiquetas - Dev. Rafael Brendolan';
  Application.CreateForm(TFrmEtiquetas, FrmEtiquetas);
  Application.Run;
end.
