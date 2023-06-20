//
//  EditProfile.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/16/23.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI


struct EditProfile: View {
    @EnvironmentObject var session: SessionStore
    @State private var username: String = ""
    @State private var profileImage: Image?
    @State private var pickedImage: Image?
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var imageData: Data = Data()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var error:String = ""
    @State private var showingAlert = false
    @State private var alertTitle: String = "Oh No😭"
    @State private var bio: String = ""
    @State private var website: String = ""
    
    
    init(session: User?){
        
        _bio = State(initialValue: session?.bio ?? "")
        _username = State(initialValue: session?.username ?? "")
        _website = State(initialValue: session?.website ?? "")
    }
    
    func loadImage(){
        guard let inputImage = pickedImage else {return }
        
        profileImage = inputImage
    }
    
    func errorCheck() -> String? {
        if username.trimmingCharacters(in: .whitespaces).isEmpty ||
            bio.trimmingCharacters(in: .whitespaces).isEmpty{
            
            return "Please fill in all fields"
        }
        return nil
        
    }
    
    
    func clear(){
        self.bio = ""
        self.username = ""
        self.imageData = Data()
        self.profileImage = Image(systemName: "person.circle.fill")
        self.website = ""
        
    }
    
    func edit() {
        if let error = errorCheck() {
            self.error = error
            self.showingAlert = true
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        let storageProfileUserId = StorageService.storageProfileId(userId: userId)
        
        let metada = StorageMetadata()
        metada.contentType = "image/jpg"
        
        StorageService.editProfile(userId: userId, username: username, bio: bio, imageData: imageData, website: website, metaData: metada, storageProfileImageRef: storageProfileUserId, onError: {
            
            (errorMesage) in
            
            self.error = errorMesage
            self.showingAlert = true
            return
        })
        
        self.clear()
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Edit Profile")
                    .font(.largeTitle)
                
                VStack {
                    Group {
                        if profileImage != nil {
                            profileImage!
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                                .padding(.top, 20)
                                .onTapGesture {
                                    self.showingActionSheet = true
                                }
                        } else {
                            WebImage(url: URL(string: session.session!.profileImageUrl)!)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                                .padding(.top, 20)
                                .onTapGesture {
                                    self.showingActionSheet = true
                                }
                        }
                    }
                }
                
                FormField(value: $username, icon: "person.fill", placeholder: "Username")
                TextField("Bio", text: $bio)
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: bio) { newValue in
                        if newValue.count > 40 {
                            bio = String(newValue.prefix(40))
                        }
                    }
                TextField("Website", text: $website)
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: website) { newValue in
                        if newValue.count > 40 {
                            website = String(newValue.prefix(40))
                        }
                    }
                
                Button(action: edit) {
                    Text("Edit")
                        .font(.title)
                        .modifier(ButtonModifiers())
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
                }
                
                Text("Changes will take effect upon login")
                    .padding()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Image("bannerback")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                )
        }
        .navigationTitle(session.session!.username)
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(pickedImage: self.$pickedImage, showImagePicker: self.$showingImagePicker, imageData: self.$imageData)
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text(""),
                buttons: [
                    .default(Text("Choose A Photo")) {
                        self.sourceType = .photoLibrary
                        self.showingImagePicker = true
                    },
                    .default(Text("Take a Photo")) {
                        self.sourceType = .camera
                        self.showingImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
    }
}
