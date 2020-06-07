using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

/// <summary>
/// AESEncryption 的摘要描述
/// </summary>
public class AESEncryption
{
    private static string  g_sKeys = "dongbinhuiasxiny";//密钥,128位  

    private static byte[] g_bKey = { 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF, 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF };

    public static string AESEncryptString(string sData)
    {
        return Convert.ToBase64String(AESEncrypt(sData, g_sKeys));
    }

    public static string AESDecryptString(string sData)
    {
        byte[] decryptBytes = AESDecrypt(Convert.FromBase64String(sData), g_sKeys);
        return Encoding.UTF8.GetString(decryptBytes);
    }


    public static byte[] AESEncrypt(string sData)
    {
        return AESEncrypt(sData, g_sKeys);
    }

    public static byte[] AESDecrypt(byte[] bData)
    {
        return AESDecrypt(bData, g_sKeys);
    }

    public static byte[] AESEncrypt(string sData, string sKey)
    {
        SymmetricAlgorithm symmetricAlgorithm = Rijndael.Create();
        byte[] inputByteArray = Encoding.UTF8.GetBytes(sData);

        symmetricAlgorithm.Key = Encoding.UTF8.GetBytes(sKey);
        symmetricAlgorithm.IV = g_bKey;

        MemoryStream memoryStream = new MemoryStream();
        CryptoStream cryptoStream = new CryptoStream(memoryStream, symmetricAlgorithm.CreateEncryptor(), CryptoStreamMode.Write);

        cryptoStream.Write(inputByteArray, 0, inputByteArray.Length);
        cryptoStream.FlushFinalBlock();

        byte[] cipherBytes = memoryStream.ToArray();

        cryptoStream.Close();
        memoryStream.Close();
        return cipherBytes;
    }

    public static byte[] AESDecrypt(byte[] bData, string sKey)
    {
        SymmetricAlgorithm symmetricAlgorithm = Rijndael.Create();

        symmetricAlgorithm.Key = Encoding.UTF8.GetBytes(sKey);
        symmetricAlgorithm.IV = g_bKey;

        byte[] decryptBytes = new byte[bData.Length];
        MemoryStream memoryStream = new MemoryStream(bData);
        CryptoStream cryptoStream = new CryptoStream(memoryStream, symmetricAlgorithm.CreateDecryptor(), CryptoStreamMode.Read);

        cryptoStream.Read(decryptBytes, 0, decryptBytes.Length);
        cryptoStream.Close();
        memoryStream.Close();
        return decryptBytes;
    }

}