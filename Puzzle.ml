(* Graph is represented as adjacency list: we have an array which for each
   vertex holds a list of adjacent vertices. *)
type graph_type = int list array

(* The internal form of the puzzle.  Endpoints is a list of (color,vertex)
   pairs after reading (read_file), but is converted to list (start,end) pairs
   in the load function.
*)
type repr =
	{
	  raw_input : string;
	  face_size : int;
	  graph     : graph_type;
	  mutable endpoints :  (int * int) list;
	}

(* n is the number of vertices *)
let create_graph n = Array.make n []

(* Add an edge between vertices s and e. *)
let add_edge g (s, e) =
  if not (List.mem e g.(s)) then (
	  g.(s) <- e :: g.(s) ;
	  g.(e) <- s :: g.(e)
	)
	  
(* Read the blocks and return the puzzle description with an empty graph. *)
let read_file fname =
  let f = open_in fname in
  let rec read_loop acc =
	try
	  read_loop ((input_line f) :: acc)
	with
		End_of_file -> acc
  in
  let llist = read_loop [] in
  let fsz = String.length (List.hd llist) in
  let lines = String.concat "" (List.rev llist) in
  let max_vert = 3 * fsz * fsz in
	if max_vert == String.length(lines) then
	  (
		close_in f ;
		{ raw_input = lines;
		  face_size = fsz;
		  graph     = create_graph max_vert;
		  endpoints = [];
		}
	  )
	else
	  raise (Failure "invalid input")

(* Given a puzzle description and two indices, connect the corresponding
   vertices in the graph.  The vertices are connected conditionally, i.e. both
   ends must be <> '.'.  This is a mutable function. *)
let connect_vertices pd i1 i2 =
  let is_digit ch = (ch >= '0') && (ch <= '9')
  in
  let if_endpoint_add v i =
	let ep = (Char.code v, i) in
	  if (is_digit v) && not (List.mem ep pd.endpoints) then
		pd.endpoints <- ep :: pd.endpoints ;
  in
  let v1  = pd.raw_input.[i1]  in
  let v2  = pd.raw_input.[i2]  in
	(
	  if (v1 <> '.') && (v2 <> '.') then add_edge pd.graph (i1, i2) ;
	  if_endpoint_add v1 i1 ;
	  if_endpoint_add v2 i2 ;
	)

(* Convert vertex (face index, row, col) to index within the flat string.  fsz
   is the face size. *)
let index_from_vertex fsz (f, r, c) = f*fsz*fsz + r*fsz + c

(* Connect grid edges on a given face. *)
let connect_grid pd f =
  let do_connect (sr, sc) (er, ec) =
	if (er < pd.face_size) && (ec < pd.face_size) then
	  connect_vertices pd
		(index_from_vertex pd.face_size (f, sr, sc))
		(index_from_vertex pd.face_size (f, er, ec)) ;
  in
  for r = 0 to pd.face_size-1 do
	for c = 0 to pd.face_size-1 do
	  (
		do_connect (r, c) (r, c+1);		(* horizontal edge *)
		do_connect (r, c) (r+1, c);		(* vertical edge *)
	  )
	done ;
	done

(* Make the graph in the puzzle description. *)
let make_graph pd =
  List.iter (fun f -> connect_grid pd f) [0; 1; 2] ;
  for i = 0 to pd.face_size-1 do
	(
	  (* top -> left *)
	  connect_vertices pd
		(index_from_vertex pd.face_size (0, pd.face_size-1, i))
		(index_from_vertex pd.face_size (1, 0,              i)) ;

	  (* top -> right *)
	  connect_vertices pd
		(index_from_vertex pd.face_size (0, i, pd.face_size-1))
		(index_from_vertex pd.face_size (2, i,              0)) ;

	  (* left -> right *)
	  connect_vertices pd
		(index_from_vertex pd.face_size (1, i, pd.face_size-1))
		(index_from_vertex pd.face_size (2, pd.face_size-1, i)) ;
	)
  done

(* Consolidate endpoints; i.e. transform from list of pairs (c1, s1), (c1,
   e1), ... into a list of pairs (s1, e1), (s2, e2), ...  Actual color values
   are not important. *)
let consolidate_endpoints pd =
  let sorted =
	List.sort (fun (c1, _) -> fun (c2, _) -> compare c1 c2) pd.endpoints
  in
  let (_, vertices) = List.split sorted in
  let rec collect = function
	  (s :: e :: rest, acc) -> collect(rest, (s, e) :: acc)
	| ([], acc) -> acc
	| _ -> assert false
  in
	collect (vertices, [])
  
let load fname =
  let pd = read_file fname in
  let _  =
	(
	  make_graph pd ;
	  pd.endpoints <- consolidate_endpoints pd ;
	)
  in
	pd
