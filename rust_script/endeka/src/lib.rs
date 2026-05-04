extern crate proc_macro;

use proc_macro::{TokenStream};
use quote::quote;
use syn::{parse_macro_input, DeriveInput};


#[proc_macro_derive(EEAD)]
pub fn derive_eead(input: TokenStream) -> TokenStream
{
    let DeriveInput { ident, .. } = parse_macro_input!(input);

    let output = quote! {
        trait EEAD {

        }

        impl EEAD for #ident {
            
        }
    };

    output.into()
}


#[proc_macro_derive(Endeka)]
pub fn derive_endeka(input: TokenStream) -> TokenStream
{
    let DeriveInput {ident, ..} = parse_macro_input!(input);

    let output = quote! {
        trait Endeka
        {
            fn sort(&mut self)
            {
            
            }
        }

        impl Endeka for #ident
        {
            fn sort(&mut self)
            {

            }
        }

        #[godot_api]
        impl ICanvasLayer for #ident
        {

        }

        #[godot_api]
        impl #ident
        {
            #[func]
            fn create(&mut self)
            {
                
            }
        }
    };

    output.into()
}