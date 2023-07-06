//
//  Main.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/13/23.
//


import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI


struct MainView: View {
    let buttonSpacing: CGFloat = 40
    @EnvironmentObject var session: SessionStore
    @State private var shouldShowMerch = false
    @State private var shouldShowBooks = false
    @State private var shouldShowDirectory = false
    @State private var shouldShowBnnTv = false
    
    @State private var shouldShowPostView = false
    
    var body: some View {
        VStack(spacing: 0) {
            Header(shouldShowPostView: $shouldShowPostView)

            Spacer().frame(height: 10)

            HStack(spacing: buttonSpacing) {
                VStack {
                    Image(systemName: "tv")
                        .font(.system(size: 38))
                        .foregroundColor(.black)
                    Text("BNN TV")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .onTapGesture {
                    shouldShowBnnTv = true
                }
                
                VStack {
                    Image(systemName: "info.circle")
                        .font(.system(size: 38))
                        .foregroundColor(.black)
                    Text("411")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .onTapGesture {
                    shouldShowDirectory = true
                }
                
                VStack {
                    Image(systemName: "cart")
                        .font(.system(size: 38))
                        .foregroundColor(.black)
                    Text("Merch")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .onTapGesture {
                    shouldShowMerch = true
                }
                
                VStack {
                    Image(systemName: "book")
                        .font(.system(size: 38))
                        .foregroundColor(.black)
                    Text("Books")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .onTapGesture {
                    shouldShowBooks = true
                }
            }
            .padding()
            .background(
                Image("frame")
                    .resizable()
                    .frame(height: 98)
                    .scaledToFill()
            )

            Spacer().frame(height: 10)

            ScrollView(.vertical, showsIndicators: false) {
                
                StoryHome()

                Divider()

                Post()

                Post(image: "profile2", caption: "Ready for Greater!")
            }
        }
        .sheet(isPresented: $shouldShowBnnTv) {
            BnnTv()
        }
        .sheet(isPresented: $shouldShowDirectory) {
            Directory()
        }
        .sheet(isPresented: $shouldShowMerch) {
            Merch()
        }
        .sheet(isPresented: $shouldShowBooks) {
            BookHome()
        }
        .sheet(isPresented: $shouldShowPostView) {
            PostView()
        }
        .navigationBarHidden(true) // Hide the navigation bar
    }
}



struct Header: View {
    @Binding var shouldShowPostView: Bool
    
    var body: some View {
        HStack {
            Image("smalllogo3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
            
            Spacer()
            
            HStack(spacing: 10) {
                Image(systemName: "square.and.pencil")
                    .onTapGesture {
                        shouldShowPostView = true // Set the variable to true on button tap
                    }
                Text("What's on your mind?")
                    .font(.footnote) // Adjust the font size as needed
                    .fontWeight(.bold) // Make the text bold
                
           //     Image(systemName: "envelope")
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 3)
    }
}
    
    
    struct PostHeader: View {
        var body: some View {
            HStack {
                HStack {
                    Image("boss1")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .cornerRadius(50)
                    
                    HStack(spacing: 4) {
                        Text("Shiba Billionaire")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
           
                Spacer()
                
                Image(systemName: "ellipsis")
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
        }
    }

struct PostContent: View {
    var image: String = "boss1"
    
    var body: some View {
        VStack (spacing: 0) {
            VStack(spacing: 0) {
                Image(image)
                    .resizable()
                    .aspectRatio(6/5, contentMode: .fit)
                
                HStack {
                    HStack(spacing: 10) {
                        Image(systemName: "heart")
                        Image(systemName: "ellipsis.bubble")
                        Image(systemName: "arrow.uturn.forward.circle")
                    }
                    
                    Spacer()
                    
                    Image("bookmark")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                
            }
            
            Spacer()
            
            
            
            // Add additional content here
        }
      //  .navigationBarTitle("")
    }
}

struct Post: View {
    var image: String = "boss1"
    var caption: String = "Building the next big thing!"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PostHeader()
            
            PostContent(image: image)
            
            Text("Liked by Ladychelle and others")
                .font(.footnote)
                .padding(.horizontal, 12)
            
            HStack(spacing: -10) {
                Text("Shiba Billionaire")
                    .font(.footnote)
                    .bold()
                    .padding(.horizontal, 12)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.footnote)
                    .foregroundColor(.blue)
                
                Text(caption)
                    .font(.footnote)
                    .padding(.horizontal, 12)
            }
            
            HStack {
                HStack(spacing: 7) {
                    Image("boss1")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .cornerRadius(50)
                    
                    Text("Add comment...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                
                Spacer()
            }
            
        }
    }
}


