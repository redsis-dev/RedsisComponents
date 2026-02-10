unit uRegister;

interface

uses
  System.SysUtils, System.Classes;

procedure Register;

implementation

uses
  DesignIntf, DesignEditors, uRDModuloDataModule, uRDPageControl, uRDTransaction,
  uRDDBDateTimePicker, uRDDBComboBox, uRDTable, uRDQuery, uRDMemTable, uRDDataSet,
  uRDConnection, uFieldType, uRDDBCheckListBox, uRDComboBox, uRDCommand, uRDCheckListBox,
  uRDDBRadioButton, uRDDBListBox;

procedure Register;
begin
  //DataModules
  RegisterNoIcon([TRDModuloDataModule]);
  RegisterCustomModule(TRDModuloDataModule, TCustomModule);
  //

  //DataComponents
  RegisterComponents('RDDataComponents', [
    TRDTransaction,
    TRDTable,
    TRDQuery,
    TRDMemTable,
    TRDDataSet,
    TRDCommand,
    TRDConnection,
    TRDStringField,
    TRDDateTimeField]);
  //

  //DataControls
  RegisterComponents('RDDataControls', [
    TRDDBDateTimePicker,
    TRDDBCheckListBox,
    TRDDBListBox,
    TRDDBComboBox,
    TRDDBRadioButton]);
  //

  //Controls
  RegisterComponents('RDControls', [
    TRDPageControl,
    TRDComboBox,
    TRDCheckListBox]);
  //
end;

end.
