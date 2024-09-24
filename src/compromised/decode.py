import base64

def decode_hex_and_base64(hex_string):
    # Decode the hexadecimal string to bytes
    decoded_bytes = bytes.fromhex(hex_string)
    decoded_length = len(decoded_bytes)
    print(f"Decoded length: {decoded_length}")
    print(f"Decoded bytes: {decoded_bytes}")

    # Decode the Base64-encoded bytes
    base64_decoded = base64.b64decode(decoded_bytes)
    print(f"Base64 decoded bytes: {base64_decoded}")

    # Convert the Base64-decoded bytes to a hexadecimal string
    hex_from_base64 = base64_decoded.decode('utf-8')
    print(f"Hex from Base64: {hex_from_base64}")

    # Convert the hexadecimal string to bytes
    final_decoded_bytes = bytes.fromhex(hex_from_base64[2:])  # Skip the '0x' prefix
    final_decoded_length = len(final_decoded_bytes)
    print(f"Final decoded length: {final_decoded_length}")
    print(f"Final decoded bytes: {final_decoded_bytes}")

    # Return the final decoded bytes as a hex string
    return hex_from_base64

hex_string_1 = "4d4867335a444531596d4a684d6a5a6a4e54497a4e6a677a596d5a6a4d32526a4e324e6b597a566b4d574934595449334e4451304e4463314f54646a5a6a526b595445334d44566a5a6a5a6a4f546b7a4d44597a4e7a5130"
hex_string_2 = "4d4867324f474a6b4d444977595751784f445a694e6a5133595459354d574d325954566a4d474d784e5449355a6a49785a574e6b4d446c6b59324d304e5449304d5451774d6d466a4e6a426959544d334e324d304d545535"

print("Decoding hex_string_1:")
private_key_1 = decode_hex_and_base64(hex_string_1)

print("\nDecoding hex_string_2:")
private_key_2 = decode_hex_and_base64(hex_string_2)

# Write the private keys to a file
with open("private_key_1.txt", "w") as file:
    file.write(private_key_1)

with open("private_key_2.txt", "w") as file:
    file.write(private_key_2)