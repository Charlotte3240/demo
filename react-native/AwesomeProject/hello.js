import {View,StyleSheet,TextInput, ScrollView, Text,Image, Button, Alert} from 'react-native';
import React, { Component } from 'react';
import Comment from './comment';
const Hello = () => {
    return(
        <ScrollView>
            <Text style={styles.label}>some default text == UILabel</Text>

            <Comment stringVar='View == UIView'></Comment>
            <View>
                <Text style={styles.comment}>image == UIImageView</Text>
                <Image style={styles.image} source={{
                    uri:"https://reactnative.dev/docs/assets/p_cat2.png"
                }}></Image>
            </View>

            <Comment stringVar="TextInput == UITextField"></Comment>
            <TextInput style={styles.inputText}  placeholder='place holder'></TextInput>
            
            <Comment stringVar='UIButton'></Comment>
            <Button
                onPress= {() => {
                    Alert.alert("你点击了按钮！")
                }}
                title='button title'
            ></Button>

        </ScrollView>
    );
};

const styles = StyleSheet.create({
    comment:{
        color:'gray',
        fontSize:20,
        textAlign:'center'
    },
    label:{
        fontSize:30,
        color:'blue'
    },
    image:{
        height:200,
        width:200
    },
    inputText:{
        height:40,
        width:300,
        borderWidth:1,
        borderColor:'gray',
        alignSelf:'center'
    }
});

export default Hello;