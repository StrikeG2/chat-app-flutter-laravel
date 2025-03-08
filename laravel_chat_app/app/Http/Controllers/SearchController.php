<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    public function search(Request $request)
    {
        $query = $request->get('query');
        
        // Vérifie que la recherche n'est pas vide
        if (empty($query)) {
            return response()->json([]);
        }
    
        // Recherche des utilisateurs dont le nom ou l'email correspond à la requête
        $user = User::where('name', 'like', '%' . $query . '%')->first(); // Utilise first() au lieu de get()
    
        // Si un utilisateur est trouvé, renvoie-le
        if ($user) {
            return response()->json($user);
        }
    
        // Si aucun utilisateur trouvé, renvoie une réponse vide
        return response()->json([]);
    }
    }
