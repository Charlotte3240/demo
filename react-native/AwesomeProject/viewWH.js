import React from 'react';
import{
    View,
    Text,
    StyleSheet
} from 'react-native';
import { Colors } from 'react-native/Libraries/NewAppScreen';

const HCView = () => {

    return(
        <>
            <View>
                <Text>
                    other file text tags
                </Text>
            </View>

            <View style={styles.flexSection}>
                <View style={styles.section1}></View>
                <View style={styles.section2}></View>
                <View style={styles.section3}></View>
                {/* <View style={{width:200,height:200,backgroundColor:'red'}} /> */}
            </View> 

        </>
    );
};

const styles = StyleSheet.create({
    flexSection:{
        // flex:1,
        height:300,
        width:300
    },
    section1:{
        backgroundColor:'powderblue',
        // width:50,
        // height:50
        flex:1,
    },
    section2:{
        backgroundColor:'skyblue',
        flex:2,
        // width:100,
        // height:100
    },
    section3:{
        backgroundColor:'steelblue',
        flex:3,
        // width:150,
        // height:150
    }
});


export default HCView;


