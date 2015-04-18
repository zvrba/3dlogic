(* Solver.  It has an imperative interface, i.e. a function is called for
   every solution found.  If we don't care about all solutions, the called
   function must bail out with an exception. *)

(* Exception that may be used for early break. *)
exception Solved of int list list

(* Set of integers. *)
module Int_cmp = struct
  type t = int
  let compare = compare
end

module IntSet = Set.Make(Int_cmp)

(* Enumerate all paths from start to end vertex that do not go through
   vertices in visited_set.  set is the set of already visited vertices, path
   accumulates the path vertices.  f is the function that is called with the
   path and the updated set (containing vertices in the path) when a path is
   found. *)
let rec do_enumerate_paths f pd (s, e) visited_set path =
  let graph = pd.Puzzle.graph in
	(* we're allowed to use an endpoint as a neighbor only if it equals e *)
  let neighbors = List.filter
	(fun v ->
	  (not (IntSet.mem v visited_set)) &&
		((v == e) || (pd.Puzzle.raw_input.[v] == 'x')))
	graph.(s)
  in
  let visit v =
	let set'  = IntSet.add v visited_set in
	let path' = v :: path in
	  if v == e then
		f (List.rev path', set')
	  else
		do_enumerate_paths f pd (v, e) set' path'
  in
	List.iter visit neighbors

(* Main routine to construct the call to do_enumerate_paths which does all the
   work. *)
let enumerate_paths f pd (s, e) visited_set =
  do_enumerate_paths f pd (s, e) (IntSet.add s visited_set) [s]
	
(* Solve puzzle pd and invoke function f with the solution (list of paths)
   when found.  f can break further search and return the result with the
   Solved exception. *)
let rec do_solve f pd set paths =
  let callback (path, set) =
	do_solve f { pd with Puzzle.endpoints = List.tl pd.Puzzle.endpoints; }
	  set (path :: paths)
  in
	match pd.Puzzle.endpoints with
		[] -> f paths
	  | e :: endpoints ->
		  enumerate_paths callback pd e set

let solve f pd = do_solve f pd IntSet.empty []

(* helper routine for testing the enumerate_paths function
   
   let g = [| [1;2;3] ; [0;2;3] ; [0;1;3] ; [0;1;2] |] ;;
   do_enumerate_paths print_path g (0, 3) (IntSet.singleton 0) [0] ;;
*)
let print_path (path, _) =
  print_char '(' ;
  List.iter (fun v -> Printf.printf "%d," v) path ;
  print_string ")\n" 
  
