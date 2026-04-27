struct Hello
{

}

extern crate proc_macro;

use proc_macro::TokenStream;

#[proc_macro_derive(IntoStringHashMap)]
pub fn derive_into_hash_map(item: TokenStream) -> TokenStream {
    todo!()
}
