(* Print usage message and exit. *)
let usage argv0 =
  prerr_string ("USAGE: " ^ argv0 ^ " INFILE\n") ;
  exit 1

(* Returns puzzle description and paths. *)
let solve_puzzle fname =
  let solution_cb paths = raise (Solve.Solved paths)
  in
  let pd = Puzzle.load Sys.argv.(1) in
	try
	  Solve.solve solution_cb pd ;
	  (pd, [])							(* return empty list if no solution *)
	with
		Solve.Solved paths -> (pd, paths)

(* Split string into chunks of length n and return a list of chunks.  Raises
   exception if the string length is not exact multiple of n. *)
let split_string str n =
  let rec loop str acc =
	let len = String.length str in
	  if len == n then
		List.rev (str :: acc)
	  else
		let first = String.sub str 0 n in
		let rest  = String.sub str n (len - n) in
		  loop rest (first :: acc)
  in
	loop str []

(* Print the grid in a bit nicer form than it was input: it corresponds to the
   connectivity graph, but lines are not drawn. *)
let print_grid pd =
  let fsz   = pd.Puzzle.face_size in
  let grid  = pd.Puzzle.raw_input in
  let lines = Array.of_list (split_string grid fsz) in
  let top_right = Array.init fsz
	(fun i -> lines.(i) ^ " " ^ lines.(i+2*fsz))
  in
  let left      = Array.sub lines fsz fsz in
  let print l   = (print_string l ; print_newline () ) in
	Array.iter print top_right ;
	Array.iter print left 

(* Print solution.  Path is marked with the color of its endpoints. *)
let print_solution (pd, paths) =
  let mark_path path =
	let color = pd.Puzzle.raw_input.[List.hd path] in
	  List.iter (fun v -> pd.Puzzle.raw_input.[v] <- color) path
  in
	if paths == [] then
	  print_string "No solution found!\n"
	else
	  (
		List.iter mark_path paths ;
		print_grid pd ;
		print_newline ()
	  )

(* main *)
let _ =
  if (Array.length Sys.argv) != 2 then
	usage Sys.argv.(0)
  else
	let soln = solve_puzzle Sys.argv.(1) in
	  print_solution soln ;
	  exit 0

