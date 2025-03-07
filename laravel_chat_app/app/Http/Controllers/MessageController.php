<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'conversation_id' => 'required|exists:conversations,id',
            'content' => 'required|string'
        ]);
    
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
