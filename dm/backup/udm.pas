unit uDM;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset;

type

  { TDM }

  TDM = class(TDataModule)
    DSFormateur: TDataSource;
    ZCNXcole: TZConnection;
    ZQryHelp: TZQuery;
    ZtblFormateur: TZTable;
  private

  public

  end;

var
  DM: TDM;

implementation

{$R *.lfm}

end.

