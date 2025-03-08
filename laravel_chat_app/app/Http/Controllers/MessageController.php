<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Message; // <-- Ajout de l'import du modèle Message

class MessageController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'conversation_id' => 'required|exists:conversations,id',
            'content' => 'required|string'
        ]);

        // Vérifier si l'utilisateur est authentifié
        if (!auth()->check()) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $message = Message::create([
            'conversation_id' => $request->conversation_id,
            'user_id' => auth()->id(),
            'content' => $request->content
        ]);

        return response()->json($message, 201);
    }

    public function index($conversationId)
    {
        $messages = Message::where('conversation_id', $conversationId)->with('user')->get();
        return response()->json($messages);
    }
}
