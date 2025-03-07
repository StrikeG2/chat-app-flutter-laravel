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
}