#light
// Learn more about F# at http://fsharp.net

(*
Mega Hello Word:
Take two command line parameters and then print
them along with the current time to the Console
*)

open System

[<EntryPoint>]
let main (args : string[])=
   // if args.Length <> 2 then
        //   failwith "Expected arguments <greeting> and <thing>"
        
        let greeting = args.[0]
        let thing = args.[1]
        
        // let timeOfDay = DateTime.ToString("hh:mm:tt")
        
        printfn "%s, %s at" greeting thing // timeOfDay
        
        // exit
        0        
        
        
        
