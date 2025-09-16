module MyModule::NFTArtShowcase {
    use aptos_framework::signer;
    use std::string::{Self, String};
    use std::vector;

    /// Struct representing an NFT artwork in the collection
    struct Artwork has store, drop, copy {
        title: String,        // Title of the artwork
        artist: String,       // Artist name
        image_url: String,    // URL to the artwork image
        description: String,  // Description of the artwork
    }

    /// Struct representing an art collection showcase
    struct ArtCollection has store, key {
        name: String,                    // Collection name
        artworks: vector<Artwork>,       // Vector of artworks in collection
        owner: address,                  // Owner of the collection
    }

    /// Function to create a new art collection showcase
    public fun create_collection(
        owner: &signer, 
        collection_name: String
    ) {
        let owner_addr = signer::address_of(owner);
        let collection = ArtCollection {
            name: collection_name,
            artworks: vector::empty<Artwork>(),
            owner: owner_addr,
        };
        move_to(owner, collection);
    }

    /// Function to add an artwork to the collection
    public fun add_artwork(
        owner: &signer,
        collection_owner: address,
        title: String,
        artist: String,
        image_url: String,
        description: String
    ) acquires ArtCollection {
        // Verify that the signer is the collection owner
        assert!(signer::address_of(owner) == collection_owner, 1);
        
        let collection = borrow_global_mut<ArtCollection>(collection_owner);
        
        let new_artwork = Artwork {
            title,
            artist,
            image_url,
            description,
        };
        
        vector::push_back(&mut collection.artworks, new_artwork);
    }
}