<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Conversation;
use Illuminate\Support\Facades\Auth;

class ConversationController extends Controller
{
    // Récupérer toutes les conversations de l'utilisateur
    public function index(Request $request)
    {
        $user = $request->user();
        $conversations = $user->conversations()->with(['participant', 'messages'])->get();
        return response()->json($conversations);
    }

    // Créer une nouvelle conversation
    public function store(Request $request)
    {
        $request->validate([
            'participant_id' => 'required|exists:users,id',
        ]);

        $conversation = Conversation::create([
            'user_id' => $request->user()->id,
            'participant_id' => $request->participant_id,
        ]);

        return response()->json($conversation, 201);
    }

    public function getUserByConversation($id)
    {
        // Récupérer la conversation par son ID
        $conversation = Conversation::find($id);

        if ($conversation) {
            // Supposons que la conversation a un utilisateur lié à elle
            $user = $conversation->user;  // Si tu utilises une relation de type `user()` dans le modèle Conversation

            return response()->json([
                'name' => $user->name,  // Nom de l'utilisateur
                'email' => $user->email, // Email de l'utilisateur
            ]);
        } else {
            return response()->json(['message' => 'Conversation not found'], 404);
        }
    }
}