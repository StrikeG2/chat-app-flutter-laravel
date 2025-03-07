<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    public function getUser(Request $request)
    {
        // Récupère l'utilisateur authentifié
        $user = Auth::user();
        
        // Retourne les informations de l'utilisateur
        return response()->json([
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            // Ajoute d'autres informations selon tes besoins
        ]);
    }
}
