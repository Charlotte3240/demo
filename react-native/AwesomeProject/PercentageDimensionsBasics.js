import React from 'react';
import {
    View,
    StyleSheet
} from 'react-native';

const PercentageView = () => {

    return(
        // <View style={{ height: '30%' }}>
        <View style={{ }}>

        <View style={{
          width:'99%',height: '5%', backgroundColor: 'powderblue'
        }} />
        <View style={{
          width: '66%', height: '10%', backgroundColor: 'skyblue'
        }} />
        <View style={{
          width: '33%', height: '20%', backgroundColor: 'steelblue'
        }} />
      </View>
    );
};


export default PercentageView;