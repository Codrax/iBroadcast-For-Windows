{***********************************************************}
{               Codruts Windows Runtime Storage             }
{                                                           }
{                        version 1.0                        }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{                                                           }
{              Copyright 2024 Codrut Software               }
{***********************************************************}

{$SCOPEDENUMS ON}

unit Cod.WindowsRT.Storage;

interface
uses
  // System
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Forms, IOUtils, System.Generics.Collections, Dialogs, ActiveX, ComObj,
  DateUtils, Math,

  // Graphics
  Vcl.Graphics,

  // Windows RT (Runtime)
  Win.WinRT,
  Winapi.Winrt,
  Winapi.Winrt.Utils,
  Winapi.DataRT,
  Winapi.CommonNames,

  // Winapi
  Winapi.CommonTypes,
  Winapi.Foundation,
  Winapi.Storage.Streams,

  // Async
  Cod.WindowsRT.AsyncEvents,

  // Cod Utils
  Cod.WindowsRT;

type
  [WinRTClassNameAttribute('Windows.Storage.Streams.InMemoryRandomAccessStream')]
  IInMemoryRandomAccessStream = interface(IRandomAccessStream)
  ['{905A0FE1-BC53-11DF-8C49-001E4FC686DA}']
  end;

  TInMemoryRandomAccessStream = class(TWinRTGenericImportI<IInMemoryRandomAccessStream>) end;

// IBuffer utilities
function BufferToBytes(Buffer: IBuffer): TBytes;
function BytesToBuffer(Bytes: TBytes): IBuffer;

// RandomAccessStream
function CreateRandomAccessStream: IRandomAccessStream;

function RandomAccessStreamRead(Stream: IRandomAccessStream; From, Length: int64): TBytes;
function RandomAccessStreamGetContents(Stream: IRandomAccessStream): TBytes;

procedure RandomAccessStreamWrite(Stream: IRandomAccessStream; AtPosition: int64; Data: TBytes);
procedure RandomAccessStreamAppend(Stream: IRandomAccessStream; Data: TBytes);
function RandomAccessStreamMakeWithData(Data: TBytes): IRandomAccessStream;

implementation

function BufferToBytes(Buffer: IBuffer): TBytes;
var
  Reader: IDataReader;
begin
  // Get reader
  Reader := TDataReader.FromBuffer(Buffer);

  // Read to bytes
  SetLength(Result, Buffer.Length);

  // Read bytes
  Reader.ReadBytes(Buffer.Length, @Result[0]);
end;

function BytesToBuffer(Bytes: TBytes): IBuffer;
var
  Writer: IDataWriter;
begin
  // Create writer
  Writer := TDataWriter.Create;

  // Write data
  Writer.WriteBytes(Length(Bytes), @Bytes[0]);

  Result := Writer.DetachBuffer;
end;

function CreateRandomAccessStream: IRandomAccessStream;
begin
  Result := TInMemoryRandomAccessStream.Create;
  // LEGACY STREAM CREATION VERSION
  {begin
  const Item = TInstanceFactory.CreateNamed<IInspectable>('Windows.Storage.Streams.InMemoryRandomAccessStream');

  if Supports(Item, IRandomAccessStream) then
    Item.QueryInterface(IRandomAccessStream, Result);}
end;

function RandomAccessStreamRead(Stream: IRandomAccessStream; From, Length: int64): TBytes;
var
  Buffer: IBuffer;
begin
  if not Stream.CanRead then
    raise Exception.Create('Stream does not support reading.');

  // Make buffer
  Buffer := TBuffer.Create( Length );

  // Get data async
  TAsyncAwait.Await(
    Stream.GetInputStreamAt(From).ReadAsync(Buffer, Length, InputStreamOptions.None)
    );

  // Convert
  Result := BufferToBytes(Buffer);
end;

function RandomAccessStreamGetContents(Stream: IRandomAccessStream): TBytes;
begin
  Result := RandomAccessStreamRead(Stream, 0, Stream.Size);
end;

procedure RandomAccessStreamWrite(Stream: IRandomAccessStream; AtPosition: int64; Data: TBytes);
var
  NewSize: integer;
  Buffer: IBuffer;
begin
  NewSize := Math.Max(integer(Stream.Size), AtPosition+Length(Data));
  Stream.Size := NewSize;

  // Buffer
  Buffer := BytesToBuffer( Data );

  // Get data async
  TAsyncAwait.Await(
    Stream.GetOutputStreamAt(AtPosition).WriteAsync(Buffer)
    );

  // Clear
  Buffer := nil;
end;

procedure RandomAccessStreamAppend(Stream: IRandomAccessStream; Data: TBytes);
begin
  RandomAccessStreamWrite(Stream, Stream.Size, Data);
end;

function RandomAccessStreamMakeWithData(Data: TBytes): IRandomAccessStream;
begin
  Result := CreateRandomAccessStream;

  RandomAccessStreamAppend(Result, Data);
end;

end.
