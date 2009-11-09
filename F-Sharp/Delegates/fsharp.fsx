#light

// Declaring values using the 'let' keyword
let hello = "Hello world"
let num = 42

// Declaring functions
let twoTimes n = 
  n * 2

// Declaring recursive functions
let rec sumNumbers nfrom nto =   
  if (nfrom > nto) then 0
  else nfrom + (sumNumbers (nfrom + 1) nto)

// Function that takes the 'aggregation operation' as an argument
let rec aggregateNumbers initial op nfrom nto =   
  if (nfrom > nto) then initial
  else op nfrom (aggregateNumbers initial op (nfrom + 1) nto)

// ----------------------------------------------------------------------------

// Working with data in F#
let data = [ 1 .. 10 ]
let data0 = List.filter (fun n -> n%2 = 0) data
let data1 = List.map (fun n -> n * 2) data0

// Using the pipelining operator
let res = 
  data 
  |> List.filter (fun n -> n%2 = 0) 
  |> List.map (fun n -> n * 2)
  |> List.length