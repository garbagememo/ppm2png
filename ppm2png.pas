program ppmconv;
{$mode objfpc}
{$modeswitch advancedrecords}
uses SysUtils,classes,FPImage, FPWritePNG;

var
    BMPBody:array of byte;
    BMPWide,BMPHigh:integer;

procedure LoadPPM(FN:string);
var
  f:text;
  bd,x,y:integer;
  r,g,b:byte;
  st:string;
  suf:integer;
begin
  assign(f,FN);reset(f);
  readln(f,st);if st<>'P3' then begin close(f);exit;end;
  readln(f,BMPWide,BMPHigh);
  readln(f,bd);
  SetLength(bmpBody,BMPWide*BMPHigh*3);
  for y:=0 to BMPHigh-1 do begin
    for x:=0 to BMPWide-1 do begin
      readln(f,r,g,b);
      suf:=( (BMPHigh-y-1)*BMPWide+x)*3;
      bmpBody[suf+2]:=r;
      bmpBody[suf+1]:=g;
      bmpBody[suf  ]:=b;
    end;
  end;
end ;

procedure WritePNG(FN:string);
var
    image : TFPCustomImage;
    writer : TFPWriterPNG;
    x,y:integer;
begin
  image := TFPMemoryImage.Create (BMPWide,BMPHigh);
  Writer := TFPWriterPNG.Create;
  Writer.WordSized:=false;
  for y:=0 to BMPHigh-1 do
    for x:=0 to BMPWide-1 do 
      image.colors[x,BMPHigh-y-1]
        :=FPColor(bmpBody[(y*BMPWide+x)*3+2]*255,
                  bmpBody[(y*BMPWide+x)*3+1]*255,
                  bmpBody[(y*BMPWide+x)*3  ]*255);
  image.SaveToFile (FN, writer);
  image.Free;
  writer.Free;
end;

var
  st:String;

begin
  if paramcount<1 then exit;
  st:=ParamStr(1);
  if UpperCase(ExtractFileExt(st))='.PPM' then begin
    LoadPPM(st);
    delete(st,length(st)-3,4);
    WritePNG(ExtractFileName(st)+'.png');
  end;
end.
  
  
