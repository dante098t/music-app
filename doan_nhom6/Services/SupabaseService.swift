import Supabase
import Foundation

class SupabaseService {
    
    static let shared = SupabaseService()
    
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://ibvtmmdvlgrdgdlgvozx.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlidnRtbWR2bGdyZGdkbGd2b3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgxMTk2MTksImV4cCI6MjA5MzY5NTYxOX0.--YMHXct1CS2m-QxcIXwGhPtidVXUOErY05-F4PoHr8"
    )
}
