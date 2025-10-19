import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';
import '../models/profile_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  // Get current user
  User? get currentUser => _client.auth.currentUser;
  String? get currentUserId => currentUser?.id;

  // Authentication
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Profile operations
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return ProfileModel.fromJson(response);
    } catch (e) {
      // Error fetching profile
      return null;
    }
  }

  Future<List<ProfileModel>> getAllProfiles() async {
    try {
      final response = await _client.from('profiles').select();
      return (response as List)
          .map((json) => ProfileModel.fromJson(json))
          .toList();
    } catch (e) {
      // Error fetching profiles
      return [];
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarColor,
  }) async {
    final updates = <String, dynamic>{};
    if (username != null) updates['username'] = username;
    if (avatarColor != null) updates['avatar_color'] = avatarColor;

    await _client.from('profiles').update(updates).eq('id', userId);
  }

  // Message operations with JOIN to get user info
  Stream<List<MessageModel>> getMessagesStream() {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .asyncMap((data) async {
          final messages = data.map((json) => MessageModel.fromJson(json)).toList();
          
          // Fetch profiles for all unique user IDs
          final userIds = messages.map((m) => m.userId).toSet();
          final profiles = <String, ProfileModel>{};
          
          for (final userId in userIds) {
            final profile = await getProfile(userId);
            if (profile != null) {
              profiles[userId] = profile;
            }
          }
          
          // Attach profile info to messages
          return messages.map((message) {
            final profile = profiles[message.userId];
            return message.copyWith(
              username: profile?.username ?? 'Unknown User',
              avatarColor: profile?.avatarColor ?? '#6B7280',
            );
          }).toList();
        });
  }

  Future<void> sendMessage(String content) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await _client.from('messages').insert({
      'user_id': currentUserId,
      'content': content,
    });
  }

  Future<void> deleteMessage(String messageId) async {
    await _client.from('messages').delete().eq('id', messageId);
  }

  Future<void> updateMessage(String messageId, String newContent) async {
    await _client.from('messages').update({
      'content': newContent,
    }).eq('id', messageId);
  }

  // Auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}