extern crate proc_macro;

use proc_macro::{TokenStream};
use quote::quote;
use syn::{parse_macro_input, DeriveInput};


#[proc_macro_derive(EndekaEEAD)]
pub fn derive(input: TokenStream) -> TokenStream {
    let DeriveInput { ident, .. } = parse_macro_input!(input);
    let output = quote! {

        trait EEAD {
            fn sort();
        }

        impl EEAD for #ident {
            fn sort()
            {
                
            }
        }
    };
    output.into()
}
