module TsTests exposing (..)

import Electron.Generator.Ts
import Electron.Ipc
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "ts"
        [ test "interface for msg with no parameters" <|
            \() ->
                Electron.Ipc.Msg "HideWindow"
                    |> Electron.Generator.Ts.generateInterface
                    |> Expect.equal
                        "interface HideWindow {\n  message: 'HideWindow'\n}"
        , test "another interface for msg with no parameters" <|
            \() ->
                Electron.Ipc.Msg "MakeItSo"
                    |> Electron.Generator.Ts.generateInterface
                    |> Expect.equal
                        "interface MakeItSo {\n  message: 'MakeItSo'\n}"
        , test "interface with Json.Encode.Value parameter" <|
            \() ->
                Electron.Ipc.MsgWithData "UploadSchematic" Electron.Ipc.JsonEncodeValue
                    |> Electron.Generator.Ts.generateInterface
                    |> Expect.equal
                        ("""
interface UploadSchematic {
  message: 'UploadSchematic'
  data: any
}
                        """ |> String.trim)
        , test "interface with parameters" <|
            \() ->
                Electron.Ipc.MsgWithData "SetPhasersTo" Electron.Ipc.String
                    |> Electron.Generator.Ts.generateInterface
                    |> Expect.equal
                        ("""
interface SetPhasersTo {
  message: 'SetPhasersTo'
  data: string
}
""" |> String.trim)
        , test "union" <|
            \() ->
                [ Electron.Ipc.Msg "HideWindow" ]
                    |> Electron.Generator.Ts.generateUnion
                    |> Expect.equal
                        "type ElmIpc = HideWindow"
        , test "union with multiple types" <|
            \() ->
                [ Electron.Ipc.Msg "Engage"
                , Electron.Ipc.MsgWithData "UploadSchematic" Electron.Ipc.JsonEncodeValue
                , Electron.Ipc.MsgWithData "SetPhasersTo" Electron.Ipc.String
                ]
                    |> Electron.Generator.Ts.generateUnion
                    |> Expect.equal
                        "type ElmIpc = Engage | UploadSchematic | SetPhasersTo"
        ]
